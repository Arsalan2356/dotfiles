{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.7";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "c3f1c7fd883b9b6d11e59d5086d00778bb815299";
    hash = "sha256-evU2nc74Eo5iR8Cg+cT7a62EWNFtQMwdFDW+tlYV0XE=";
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
  cargoHash = "sha256-3pUi49wcP0GTdzBTy+dljroYNoQHs9oSvWMObbUc0Ro=";
  doCheck = false;

  cargoBuildType = "prod";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
