{ pkgs }:

pkgs.writeShellScriptBin "grimBlast" ''
grimblast -f copysave area /mnt/G/Rnd/Screenshots/$(date '+%Y-%m-%d_%H-%M_%S').png

''
