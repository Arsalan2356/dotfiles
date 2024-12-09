{ pkgs }:

let
  addBins = list: builtins.concatStringsSep ":" (builtins.map(p : "${p}/bin") list);

  deps = with pkgs; [
    dart-sass
    esbuild
    bun
    jq
    pavucontrol
  ];


in
  pkgs.writeShellScriptBin "ags-wrapped" ''
    export PATH=$PATH:${addBins deps}
    /etc/profiles/per-user/rc/bin/ags -c ${toString ./config/config.js} $@
  ''

