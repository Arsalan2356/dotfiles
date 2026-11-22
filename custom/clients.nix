{ pkgs }:

pkgs.writeShellScriptBin "hyprclients" ''
hyprctl clients -j | jq -r '.[] | .address + "<separator>" + (.initialTitle | gsub("[\n\r]"; " ")) + "<separator>" + (.workspace.id | tostring) + "<separator>" + (.focusHistoryID | tostring) + "<separator>" + (.title | gsub("[\n\r]"; " ")) + "<separator>" + .class'
''
