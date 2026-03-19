{ pkgs }:

pkgs.writeShellScriptBin "grimBlast" ''
grimblast -f copysave area /mnt/G/Screenshots/$(date '+%Y-%m-%d_%H-%M_%S').png

''
