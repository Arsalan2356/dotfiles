{ pkgs, ... }:
let
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.arduino
    p.asm
    p.bash
    p.c
    p.c_sharp
    p.cmake
    p.comment
    p.commonlisp
    p.cpp
    p.css
    p.csv
    p.d
    p.dart
    p.diff
    p.disassembly
    p.gitattributes
    p.gitcommit
    p.gitignore
    p.go
    p.gomod
    p.gosum
    p.html
    p.http
    p.hyprlang
    p.ini
    p.java
    p.javascript
    p.jq
    p.jsdoc
    p.json
    p.json5
    p.jsonnet
    p.julia
    p.kotlin
    p.latex
    p.llvm
    p.lua
    p.luadoc
    p.make
    p.markdown_inline
    p.matlab
    p.meson
    p.nasm
    p.objdump
    p.ocaml
    p.ocamllex
    p.odin
    p.pascal
    p.perl
    p.php
    p.python
    p.r
    p.regex
    p.ruby
    p.rust
    p.scss
    p.sql
    p.typescript
    p.typespec
    p.udev
    p.v
    p.vim
    p.vimdoc
    p.vue
    p.xml
    p.yaml
    p.yuck
    p.zig
    p.ziggy
  ]));
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };

in {
  home.packages = with pkgs; [
    fd
    lua-language-server
    asm-lsp
    bash-language-server
    llvmPackages_19.libcxxClang
    llvmPackages_19.clang-tools
    cpplint
    black
    python312Packages.autopep8
    python312Packages.debugpy
    delve
    gopls
    hyprls
    java-language-server
    jq
    kotlin-language-server
    luaformatter
    mdformat
    mesonlsp
    nil
    nixpkgs-fmt
    ocamlPackages.ocaml-lsp
    prettierd
    pylint
    ruby-lsp
    sqls
    # staticcheck
    go-tools
    typescript-language-server
    # xmlformat
    yaml-language-server
    yamlfmt
    yamllint
    zls
    nodejs_22
    ols
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    coc.enable = false;
    withNodeJs = true;
    plugins = [
	    treesitterWithGrammars
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
  home.file."./.config/nvim/lua/rc/init.lua".text = ''
  require("rc.set")
  require("rc.remap")
  vim.opt.runtimepath:append("${treesitter-parsers}")
  '';

  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    source = treesitterWithGrammars;
    recursive = true;
  };
}
