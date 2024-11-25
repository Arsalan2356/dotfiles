{ pkgs }:

pkgs.writeShellScriptBin "hypractive" ''
hyprctl activeworkspace -j | jq '.id'
''
