{ pkgs }:

pkgs.writeShellScriptBin "hypractive" ''
hyprctl activeworkspace -j | jq -r '(.id | tostring) + "<separator>" + (.windows | tostring)'
''
