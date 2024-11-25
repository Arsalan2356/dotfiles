{ pkgs }:

pkgs.writeShellScriptBin "btkitty" ''
  kitty --session "bluetuith"
''
