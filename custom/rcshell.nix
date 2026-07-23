{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.1";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "044bd5a67d4d48ffdac38c643438bb94c10f87f0";
    hash = "sha256-r5KelGlkBFPNR2+JuIuI4BRBTXx33trkvOwqcHidR0Q=";
  };

  # src = builtins.fetchGit {
  #   url = "file:///home/rc/newshell/rust/rcshell/";
  # };

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
  cargoHash = "sha256-sRwHTSnBGEKyEpiTyIYUVfMvpGzROQba/+tqaMbLssM=";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
