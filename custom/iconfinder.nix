{ lib, pkgs }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "iconfinder";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "Arsalan2356";
    repo = "iconfinder";
    rev = "213c8fb180580d30284947d306f0bf02e38456bf";
    hash = "sha256-yaA6DGxJ350lauGevEUowDy//frN+xPBfb1PLvaREcw=";
  };

  cargoHash = "sha256-8cvwIA3QKW9eusepPIfUUggSKWFqdvQxOixrnD1gFBY=";

  meta = {
    description = "Command-line Icon Finder";
    homepage = "https://github.com/Arsalan2356/iconfinder";
    license = lib.licenses.free;
    maintainers = [ ];
  };
}