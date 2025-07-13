
{ pkgs }:

pkgs.writeShellScriptBin "hyprworkspaces" ''
hyprctl workspaces -j | jq -r '.[] | (.windows | tostring)'
''
