{ lib, pkgs }:

pkgs.master.rustPlatform.buildRustPackage rec {
  pname = "rcshell";
  version = "0.1.3";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "rcshell";
    rev = "e8e802a0938116b2ac9d2057b7a632e56e38e661";
    hash = "sha256-yowCZZdDhA1D0gVxTXE1wGZccm0WRT+UGhXEpNgJt9Y=";
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
  cargoHash = "sha256-WM2iyCYcmiM3OmtUePqReAi9JQcUH2KZQCCxrZMvrAw=";
  doCheck = false;

  meta = {
    description = "Custom Hyprland Layer Shell";
    homepage = "https://github.com/Arsalan2356/rcshell";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}
