{ pkgs }:

pkgs.writeShellScriptBin "hyprclients" ''
hyprctl clients -j | jq -r '.[] | .address + "<separator>" + .initialTitle + "<separator>" + (.workspace.id | tostring) + "<separator>" + (.focusHistoryID | tostring) + "<separator>" + .title + "<separator>" + .class'
''
