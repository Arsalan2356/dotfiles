{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    (import ./grimblast.nix { inherit pkgs; })
    (import ./sysinfo.nix { inherit pkgs; })
    (import ./clients.nix { inherit pkgs; })
    (import ./workspaces.nix { inherit pkgs; })
    (import ./active.nix { inherit pkgs; })
    (import ./bluetooth.nix { inherit pkgs; })
    (import ./iconfinder.nix { inherit lib pkgs; })
    (import ./audiomonitor.nix { inherit pkgs; })
    (pkgs.callPackage ./audiorelay.nix {})
  ];
}
