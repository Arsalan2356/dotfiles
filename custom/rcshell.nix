{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.8";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "5490ff2ec1f206a6594cdc9f6989af0f61217b15";
    hash = "sha256-3axhX+O05D2O8Gvs6BZoutK3OYKvuQY7FTGN057Wm1I=";
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
  cargoHash = "sha256-vPMzLnrejIqFUZ5Ti2tv5zl+NLQ8Z7Hw5cXDV2XfmlI=";
  doCheck = false;

  cargoBuildType = "prod";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
