{
  fetchFromGitHub,
  lib,
  llvmPackages,
  makeBinaryWrapper,
  which,
}: let
  inherit (llvmPackages) stdenv;
in
  stdenv.mkDerivation {
    pname = "odin";
    version = "2024-12-06";

    src = fetchFromGitHub {
      owner = "odin-lang";
      repo = "Odin";
      rev = "dev-2024-12";
      hash = "sha256-BkPdVzgbEc3S4eSi5TbFKPzkRGkaJTILN/g9o8hfdEw=";
    };

    patches = [./odin-system-raylib.patch];

    dontConfigure = true;
    LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

    buildFlags = ["release"];

    nativeBuildInputs = [
      makeBinaryWrapper
      which
    ];

    postPatch = ''
      patchShebangs build_odin.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp odin $out/bin/odin

      mkdir -p $out/share
      cp -r {base,core,shared} $out/share

      mkdir -p $out/share/vendor/raylib
      cp -r vendor/raylib/{rlgl,*.odin} $out/share/vendor/raylib

      # make -C "$out/share/vendor/cgltf/src/"
      # make -C "$out/share/vendor/stb/src/"
      # make -C "$out/share/vendor/miniaudio/src/"

      wrapProgram $out/bin/odin \
        --set-default ODIN_ROOT $out/share \
        --prefix PATH : ${
        lib.makeBinPath (
          with llvmPackages; [
            bintools
            llvm
            clang
            lld
          ]
        )
      }

      runHook postInstall
    '';
  }
