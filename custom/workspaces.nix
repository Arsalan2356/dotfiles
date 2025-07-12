
{ pkgs }:

pkgs.writeShellScriptBin "hyprworkspaces" ''
hyprctl workspaces -j | jq -r '.[] | (.id | tostring) + "," + (.windows | tostring)'
''
