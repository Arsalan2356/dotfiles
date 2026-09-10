{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.6";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "88bd4fde5dbed573be407f56c6bf549ba4d479bc";
    hash = "sha256-BQXFy6N1a2hpkCMSxwXOlT4AEWgSCN6u5l5ljrt5fl8=";
  };

  nativeBuildInputs = with pkgs.master; [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = with pkgs.master; [
    gtk4
    gtk4-layer-shell
    librsvg
    gobject-introspection
    gdk-pixbuf
  ];

  useCargoFetchVendor = true;
  cargoHash = "sha256-r76uRQkLAI+2WGguWrgOwalNaIchAXqk4PRMtU4ptl8=";
  doCheck = false;

  cargoBuildType = "prod";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
