{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.4";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "16c340b18cbc89d8f330167c35da603efa90fd67";
    hash = "sha256-5HNZGC9v/aKmcFx+Lzy3bmeu7TrkszyrBFBI1oZZlZQ=";
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
  cargoHash = "sha256-hlS+d4TDTq/1BdS+xA1lh32QQhv4SdACp7a7enys1Dg=";
  doCheck = false;

  cargoBuildType = "prod";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
