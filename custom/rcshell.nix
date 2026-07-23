{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "6907312c5e4bd55d6bdd137b01cb494e7ccf6439";
    hash = "sha256-1xE8Of5OxRn2XrjNIx4bIsP1u6r6f89xO2RbAoAhy70=";
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
  cargoHash = "sha256-DHGhp0rzTKjJuSgpctfxCzV601ovFQny+ip35MFCEbY=";

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
