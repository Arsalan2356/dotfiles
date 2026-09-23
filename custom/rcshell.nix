{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.9";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "924970783c64e8240e26f065da6d48ad2adebfa5";
    hash = "sha256-eyW1l0aFBdR/aZ3EjEkiOnsp/ryEbVUb5Dl5fPox3LM=";
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
  cargoHash = "sha256-9oScFvykOLsXPwl9gLiyxtXH7oufUPjvGM3SkX7v88o=";
  doCheck = false;

  cargoBuildType = "prod";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
