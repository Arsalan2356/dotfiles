"""ComfyUI image_gen backend for Hermes.

Runs an API-format ComfyUI workflow (ComfyUI → Workflow → Export (API)) against a ComfyUI
server, injecting the prompt, a seed and the output size, then returns the first saved image
so the ``image_generate`` tool shows it like any other provider's output.

Config (``config.yaml``)::

    image_gen:
      provider: comfyui
      comfyui:
        host: http://127.0.0.1:8188          # ComfyUI server
        workflow: Flux2-Klein-GGUF.json      # path; relative paths resolve against $HERMES_HOME
        timeout: 600                         # seconds to wait for the job
        # Optional overrides (auto-detected when omitted):
        # prompt_node: "131:115"             # node whose text input receives the prompt
        # negative_node: "..."               # node whose text receives negative_prompt
        # seed_node: "131:114"
        # sizes: {square: [1024, 1024], landscape: [1344, 768], portrait: [768, 1344]}

Env overrides: ``COMFYUI_HOST``, ``COMFYUI_WORKFLOW``.
"""

from __future__ import annotations

import base64
import copy
import json
import logging
import os
import random
import time
import uuid
from pathlib import Path
from typing import Any, Optional

from agent.image_gen_provider import (
    DEFAULT_ASPECT_RATIO, ImageGenProvider, error_response, resolve_aspect_ratio, save_b64_image,
    success_response)

logger = logging.getLogger(__name__)

PROVIDER = "comfyui"
DEFAULT_HOST = "http://127.0.0.1:8188"
DEFAULT_WORKFLOW = "Flux2-Klein-GGUF.json"
# ~1 MP, multiples of 64 — safe for Flux / Flux 2 / SDXL.
DEFAULT_SIZES = {"square": (1024, 1024), "landscape": (1344, 768), "portrait": (768, 1344)}

TEXT_NODES = {"CLIPTextEncode", "CLIPTextEncodeFlux", "CLIPTextEncodeSD3", "CLIPTextEncodeSDXL"}
SEED_FIELDS = ("noise_seed", "seed")
IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".webp", ".gif"}


# ── config ──────────────────────────────────────────────────────────────────

def _cfg() -> dict[str, Any]:
    try:
        from hermes_cli.config import load_config

        section = (load_config() or {}).get("image_gen") or {}
        sub = section.get(PROVIDER) if isinstance(section, dict) else None
        return sub if isinstance(sub, dict) else {}
    except Exception as exc:  # pragma: no cover - config errors shouldn't crash the tool
        logger.debug("comfyui: could not read config: %s", exc)
        return {}


def _hermes_home() -> Path:
    try:
        from hermes_constants import get_hermes_home

        return Path(get_hermes_home())
    except Exception:
        return Path(os.environ.get("HERMES_HOME") or Path.home() / ".hermes")


def _host(cfg: dict[str, Any]) -> str:
    return (os.environ.get("COMFYUI_HOST") or str(cfg.get("host") or "") or DEFAULT_HOST).rstrip("/")


def _workflow_path(cfg: dict[str, Any]) -> Path:
    raw = os.environ.get("COMFYUI_WORKFLOW") or str(cfg.get("workflow") or "") or DEFAULT_WORKFLOW
    path = Path(os.path.expanduser(raw))
    return path if path.is_absolute() else _hermes_home() / path


def _sizes(cfg: dict[str, Any]) -> dict[str, tuple[int, int]]:
    sizes = dict(DEFAULT_SIZES)
    custom = cfg.get("sizes")
    if isinstance(custom, dict):
        for key, val in custom.items():
            if isinstance(val, (list, tuple)) and len(val) == 2:
                sizes[str(key)] = (int(val[0]), int(val[1]))
    return sizes


# ── workflow injection ──────────────────────────────────────────────────────

def _is_link(value: Any) -> bool:
    return isinstance(value, list) and len(value) == 2 and isinstance(value[0], str)


def _ancestors(wf: dict[str, Any]) -> set[str]:
    """Node ids reachable backwards from output (Save*/Preview*) nodes — what ComfyUI executes."""
    outputs = [nid for nid, n in wf.items()
               if str(n.get("class_type", "")).startswith(("SaveImage", "PreviewImage"))]
    seen: set[str] = set()
    stack = list(outputs)
    while stack:
        nid = stack.pop()
        if nid in seen or nid not in wf:
            continue
        seen.add(nid)
        for val in (wf[nid].get("inputs") or {}).values():
            if _is_link(val):
                stack.append(val[0])
    return seen


def _text_nodes(wf: dict[str, Any], live: set[str]) -> tuple[Optional[str], Optional[str]]:
    """(positive_id, negative_id) among live text-encode nodes, using titles / sampler wiring."""
    cands = [nid for nid in wf if nid in live and wf[nid].get("class_type") in TEXT_NODES
             and not _is_link((wf[nid].get("inputs") or {}).get("text"))]
    if not cands:
        return None, None

    def title(nid: str) -> str:
        return str((wf[nid].get("_meta") or {}).get("title", "")).lower()

    neg = next((n for n in cands if "neg" in title(n)), None)
    # Wiring hint: whatever feeds a sampler's "negative" input is the negative prompt.
    if neg is None:
        for node in wf.values():
            link = (node.get("inputs") or {}).get("negative")
            if _is_link(link) and link[0] in cands:
                neg = link[0]
                break
    pos = next((n for n in cands if "pos" in title(n) and n != neg), None)
    pos = pos or next((n for n in cands if n != neg), None)
    return pos, neg


def _inject(wf: dict[str, Any], cfg: dict[str, Any], *, prompt: str, negative: str,
            seed: int, width: int, height: int) -> tuple[dict[str, Any], Optional[str]]:
    wf = copy.deepcopy(wf)
    live = _ancestors(wf)

    pos_id, neg_id = _text_nodes(wf, live)
    pos_id = str(cfg.get("prompt_node") or "") or pos_id
    neg_id = str(cfg.get("negative_node") or "") or neg_id
    if not pos_id or pos_id not in wf:
        return wf, "Could not find a prompt (CLIPTextEncode) node; set image_gen.comfyui.prompt_node"
    wf[pos_id]["inputs"]["text"] = prompt
    if negative and neg_id and neg_id in wf:
        wf[neg_id]["inputs"]["text"] = negative

    seed_node = str(cfg.get("seed_node") or "")
    for nid in ([seed_node] if seed_node else [n for n in wf if n in live]):
        inputs = wf.get(nid, {}).get("inputs") or {}
        for field in SEED_FIELDS:
            if field in inputs and not _is_link(inputs[field]):
                inputs[field] = seed

    # Every live node with literal width+height (latent + Flux2Scheduler, etc.) gets the new size.
    for nid in live:
        inputs = wf[nid].get("inputs") or {}
        if all(k in inputs and not _is_link(inputs[k]) for k in ("width", "height")):
            inputs["width"], inputs["height"] = width, height

    for nid in live:  # unique-ish filenames on the server side
        inputs = wf[nid].get("inputs") or {}
        if wf[nid].get("class_type") == "SaveImage" and not _is_link(inputs.get("filename_prefix")):
            inputs["filename_prefix"] = "hermes"
    return wf, None


# ── HTTP ────────────────────────────────────────────────────────────────────

def _interrupted() -> bool:
    try:
        from tools.interrupt import is_interrupted

        return bool(is_interrupted())
    except Exception:
        return False


def _session_platform() -> str:
    """Active platform, resolved the same way as agent.prompt_builder (webui sets 'webui')."""
    import sys

    platform = os.environ.get("HERMES_PLATFORM") or os.environ.get("HERMES_SESSION_PLATFORM")
    if platform:
        return platform
    get_env = getattr(sys.modules.get("gateway.session_context"), "get_session_env", None)
    try:
        return (get_env("HERMES_SESSION_PLATFORM") if get_env else "") or ""
    except Exception:
        return ""


def _renders_media_tags() -> bool:
    """MEDIA:/path tags render on the web UI and chat gateways, but print as literal text in the CLI/TUI."""
    return _session_platform().strip().lower() not in {"", "cli", "tui", "local"}


def _run(host: str, wf: dict[str, Any], timeout: float) -> tuple[Optional[bytes], str, Optional[str], str]:
    """Submit and wait. Returns (image_bytes, ext, error, error_type)."""
    import requests

    client_id = uuid.uuid4().hex
    try:
        r = requests.post(f"{host}/prompt", json={"prompt": wf, "client_id": client_id}, timeout=30)
    except requests.RequestException as exc:
        return None, "", f"Cannot reach ComfyUI at {host}: {exc}", "connection_error"
    if r.status_code != 200:
        try:
            body = r.json()
            detail = json.dumps({"error": body.get("error"), "node_errors": body.get("node_errors")})[:1500]
        except Exception:
            detail = r.text[:1500]
        return None, "", f"ComfyUI rejected the workflow ({r.status_code}): {detail}", "api_error"
    prompt_id = r.json().get("prompt_id")
    if not prompt_id:
        return None, "", f"ComfyUI returned no prompt_id: {r.text[:300]}", "invalid_response"

    deadline = time.monotonic() + timeout
    entry: dict[str, Any] = {}
    while time.monotonic() < deadline:
        if _interrupted():
            try:
                requests.post(f"{host}/interrupt", timeout=5)
            except requests.RequestException:
                pass
            return None, "", "Image generation interrupted by user (ComfyUI job cancelled).", "interrupted"
        try:
            h = requests.get(f"{host}/history/{prompt_id}", timeout=15)
            entry = (h.json() or {}).get(prompt_id) or {}
        except (requests.RequestException, ValueError):
            entry = {}
        status = entry.get("status") or {}
        if status.get("status_str") == "error":
            msgs = [m for m in status.get("messages", []) if m and m[0] == "execution_error"]
            detail = msgs[-1][1] if msgs else status
            if isinstance(detail, dict):
                detail = {k: detail.get(k) for k in ("node_id", "node_type", "exception_message")}
            return None, "", f"ComfyUI execution error: {json.dumps(detail)[:1500]}", "api_error"
        if entry.get("outputs") and status.get("completed", True):
            break
        time.sleep(1.0)
    else:
        return None, "", f"ComfyUI job {prompt_id} did not finish within {int(timeout)}s", "timeout"

    for node_out in (entry.get("outputs") or {}).values():
        for img in node_out.get("images") or []:
            if img.get("type") != "output":
                continue
            name = img.get("filename", "")
            ext = Path(name).suffix.lower()
            if ext not in IMAGE_EXTS:
                continue
            try:
                v = requests.get(f"{host}/view", params={
                    "filename": name, "subfolder": img.get("subfolder", ""), "type": "output"}, timeout=60)
                v.raise_for_status()
            except requests.RequestException as exc:
                return None, "", f"Could not download ComfyUI output {name}: {exc}", "io_error"
            return v.content, ext.lstrip(".").replace("jpeg", "jpg"), None, ""
    return None, "", "ComfyUI finished but produced no saved image (is there a SaveImage node?)", "empty_response"


# ── provider ────────────────────────────────────────────────────────────────

class ComfyUIImageGenProvider(ImageGenProvider):
    @property
    def name(self) -> str:
        return PROVIDER

    @property
    def display_name(self) -> str:
        return "ComfyUI (local workflow)"

    def is_available(self) -> bool:
        return _workflow_path(_cfg()).is_file()

    def list_models(self) -> list[dict[str, Any]]:
        wf = _workflow_path(_cfg())
        return [{"id": wf.stem, "display": f"Workflow: {wf.name}", "speed": "local GPU",
                 "strengths": "Your own ComfyUI workflow", "price": "free"}]

    def default_model(self) -> Optional[str]:
        return _workflow_path(_cfg()).stem

    def get_setup_schema(self) -> dict[str, Any]:
        return {"name": "ComfyUI", "badge": "local",
                "tag": "Your ComfyUI server + API-format workflow (image_gen.comfyui in config.yaml)",
                "env_vars": []}

    def capabilities(self) -> dict[str, Any]:
        return {"modalities": ["text"], "max_reference_images": 0}

    def generate(self, prompt: str, aspect_ratio: str = DEFAULT_ASPECT_RATIO, *,
                 image_url: Optional[str] = None, reference_image_urls: Optional[list[str]] = None,
                 **kwargs: Any) -> dict[str, Any]:
        prompt = (prompt or "").strip()
        aspect = resolve_aspect_ratio(aspect_ratio)
        cfg = _cfg()
        wf_path = _workflow_path(cfg)
        model = wf_path.stem

        def fail(msg: str, kind: str) -> dict[str, Any]:
            return error_response(error=msg, error_type=kind, provider=PROVIDER, model=model,
                                  prompt=prompt, aspect_ratio=aspect)

        if not prompt:
            return fail("Prompt is required and must be a non-empty string", "invalid_argument")
        if image_url or reference_image_urls:
            return fail("This ComfyUI workflow is text-to-image only; image_url / reference images "
                        "are not supported.", "modality_unsupported")
        try:
            workflow = json.loads(wf_path.read_text())
        except FileNotFoundError:
            return fail(f"Workflow file not found: {wf_path} (set image_gen.comfyui.workflow)", "config_error")
        except ValueError as exc:
            return fail(f"Workflow {wf_path} is not valid JSON: {exc}", "config_error")
        if not isinstance(workflow, dict) or "nodes" in workflow:
            return fail(f"{wf_path.name} is in editor format; re-export it via Workflow → Export (API)",
                        "config_error")

        width, height = _sizes(cfg).get(aspect, DEFAULT_SIZES["square"])
        seed = kwargs.get("seed")
        seed = int(seed) if isinstance(seed, (int, float, str)) and str(seed).lstrip("-").isdigit() \
            and int(seed) >= 0 else random.randint(0, 2**48)
        negative = str(kwargs.get("negative_prompt") or "")

        wf, err = _inject(workflow, cfg, prompt=prompt, negative=negative, seed=seed,
                          width=width, height=height)
        if err:
            return fail(err, "config_error")

        data, ext, err, kind = _run(_host(cfg), wf, float(cfg.get("timeout") or 600))
        if err:
            return fail(err, kind)
        try:
            path = save_b64_image(base64.b64encode(data).decode(), prefix=f"comfyui_{model}",
                                  extension=ext or "png")
        except Exception as exc:
            return fail(f"Could not save image to cache: {exc}", "io_error")
        extra: dict[str, Any] = {"seed": seed, "width": width, "height": height, "workflow": str(wf_path)}
        if _renders_media_tags():
            # Smaller local models tend to write ![alt](/local/path), which chat UIs block for local
            # files. Spell out the one syntax that renders, right next to the path.
            extra["how_to_show_user"] = (
                f"To display this image, put this exact line on its own line in your reply: MEDIA:{path} "
                "— do NOT use Markdown image syntax ![...](...) for it, local paths in Markdown do not render.")
        return success_response(image=str(path), model=model, prompt=prompt, aspect_ratio=aspect,
                                provider=PROVIDER, extra=extra)


def register(ctx) -> None:
    ctx.register_image_gen_provider(ComfyUIImageGenProvider())
