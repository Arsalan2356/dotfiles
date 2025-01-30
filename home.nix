{ config, pkgs, pkgs-custom, pkgs-master, inputs, ... }:
let
  tokyonight = pkgs.tokyonight-gtk-theme.overrideAttrs (old : {
    src = pkgs.fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Tokyonight-GTK-Theme";
      rev = "4dc45d60bf35f50ebd9ee41f16ab63783f80dd64";
      hash = "sha256-AKZA+WCcfxDeNrNrq3XYw+SFoWd1VV2T9+CwK2y6+jA=";
    };
  });
  customOhMyZshTheme = ''
    PROMPT='%F{#c0caf5}λ %~%{$reset_color%} $(git_prompt_info)%{$reset_color%}'
    RPROMPT="%F{#c0caf5} %D{%d/%m/%Y | %H:%M:%S}%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  '';
  csystem = pkgs.stdenv.hostPlatform.system;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rc";
  home.homeDirectory = "/home/rc";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #    echo "Hello, ${config.home.username}!"
    # '')

    # Dev Packages
    progress
    ripgrep
    ripgrep-all
    tree-sitter
    lua54Packages.luarocks
    wget
    go
    php83Packages.composer
    php
    rustup
    julia_19-bin
    curlFull
    libdbusmenu-gtk3
    jc
    gst_all_1.gstreamer
    godot_4-mono
    playerctl
    nvd
    eza
    (pkgs.callPackage ./odin/odin.nix {})
    pkgs-master.raylib


    # General
    bluetuith
    linux-wifi-hotspot
    vesktop
    gedit
    fsearch
    pinta
    xarchiver
    nwg-drawer
    inputs.hyprland-contrib.packages.${csystem}.grimblast
    pinta
    qbittorrent
    bitwarden-desktop
    linux-wallpaperengine


    # File Stuff
    nnn
    ncdu
    qdirstat
    gsmartcontrol


    # Clipboard
    nwg-clipman
    cliphist
    wl-clipboard


    # Game Stuff
    heroic
    winetricks
    lutris
    protonup-qt

    # Audio/Video
    obs-cmd
    ffmpeg-full
    mpv
    spotify


    inputs.aagl.packages.${csystem}.anime-game-launcher
    inputs.aagl.packages.${csystem}.anime-games-launcher
    inputs.aagl.packages.${csystem}.honkers-launcher
    inputs.aagl.packages.${csystem}.honkers-railway-launcher
    inputs.aagl.packages.${csystem}.sleepy-launcher
    inputs.aagl.packages.${csystem}.wavey-launcher
  ];


  gtk = {
    enable = true;
    font.name = "Hack";
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus Dark";
    theme.package = tokyonight;
    theme.name = "Tokyonight-Dark";
  };

  imports = [
    ./neovim
    inputs.ags.homeManagerModules.default
  ];

  # AGS 1.9.0 bar
  programs.ags = {
    enable = true;
    configDir = null;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
    ];
  };

  # Enable direnv and nix-direnv
  programs.direnv = {
    enable = true;
    silent = false;
    nix-direnv.enable = true;
    # Disable ZSH integration and call it manually
    # This is to change the colors when loading into a direnv
    enableZshIntegration = false;
  };

  # Foot Terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
	font = "monospace:size=11";
      };
      colors = {
	background = "1a1b26";
	regular0 = "1a1b26";
	selection-background = "c0caf5";
	selection-foreground = "1a1b26";
      };
    };
  };

  # Fuzzel App Launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
	layer = "overlay";
	prompt = "\"λ \"";
	terminal = "foot -e";
	match-counter = "yes";
	line-height = "28";
	lines = "10";
	font = "monospace:size=15";
	anchor = "top";
	y-margin = "150";
	width = "50";
	tabs = "4";
	show-actions = "yes";
      };
      colors = {
	background = "#1a1b26e6";
	text = "#c0caf5ff";
	prompt = "#c0caf5ff";
	placeholder = "#c0caf5ff";
	input = "#c0caf5ff";
	match = "#79a0f5ff";
	selection = "#54577bff";
	selection-text = "#c0caf5ff";
	selection-match = "#79a0f5ff";
	counter = "#c0caf5ff";
	border = "#1a1b26e6";
      };
    };
  };

  # fuzzy finder
  programs.fzf.enable = true;


  # OBS
  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  # Zoxide searching
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Zsh with plugins
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
	"brackets"
      ];
      styles = {
	reserved-word = "fg=#24acd4";
	precommand = "fg=green,bold";
	commandseparator = "fg=#c0caf5";
	hashed-command = "fg=#c0caf5";
	autodirectory = "fg=green,bold";
	path = "fg=#c0caf5";
	globbing = "fg=#24acd4";
	history-expansion = "fg=#24acd4";
	single-hyphen-option = "fg=#c0caf5";
	double-hyphen-option = "fg=#c0caf5";
	assign = "fg=#c0caf5";
	redirection = "fg=#c0caf5";
	comment = "fg=#c0caf5";
	default = "fg=#c0caf5";
	arg0 = "fg=green,bold";
	none = "fg=#c0caf5";
      };
    };
    autocd = true;
    sessionVariables = {
      CASE_SENSITIVE = "true";
      ENABLE_CORRECTION = "true";
      HIST_STAMPS = "yyyy-mm-dd";
      NNN_PLUG = "f:fzcd;p:preview-tui;d:dups;";
      NNN_FIFO = "/tmp/nnn.fifo";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" ];
      theme = "lambdaf";
      custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
    };
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
    };

    shellAliases = {
      ls = "eza -aF";
      cd = "z";
      cdi = "zi";
      cpr = "rsync -aHAX --info=progress2 --no-inc-recursive";
      diff = "${pkgs.coreutils-full}/bin/ls -v1 /nix/var/nix/profiles | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nvd diff";
      update = "sudo nixos-rebuild switch --flake .#rc && diff";
      setup = "cp ~/default/shell.nix . && chmod 644 ./shell.nix && echo \"use nix\" >> .envrc && direnv allow && echo \"Setup directory with .envrc and default shell.nix\"";
      startwaydroid = "sudo systemctl start waydroid-container && waydroid session start";
      stopwaydroid = "waydroid session stop && sudo systemctl stop waydroid-container";
    };
    initExtra = ''
bindkey -s "^[[1;2D" 'cd ..\n'
export DIRENV_LOG_FORMAT="$(printf "\033[38;2;192;202;245mdirenv: %%s\033[0m")"
eval "$(direnv hook zsh)"
_direnv_hook() {
eval "$(direnv export zsh 2> >(egrep -v -e '^(.*)direnv: export' >&2))"
};
zshaddhistory() { whence ''${''${(z)1}[1]} >| /dev/null || return 1 }
'';

  };

  # Enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    package = pkgs-master.hyprland;
    plugins = with pkgs-master.hyprlandPlugins; [
      hy3
    ];

    extraConfig = builtins.readFile ./hyprland.txt;
  };

  # Dunst Notifications
  services.dunst = {
    enable = true;
    settings = {
      global = {
	progress_bar_corner_radius = 20;
	frame_width = 0;
	gap_size = 8;
	separator_color = "#ffffffff";
	font = "Monospace 11";
	icon_theme = "Papirus Dark, Papirus, breeze-dark, breeze";
	corner_radius = 20;
      };
      urgency_low = {
	background = "#565f89";
	foreground = "#c0caf5";
      };
      urgency_normal = {
	background = "#9a9fb8";
      };
      urgency_critical = {
	background = "#cccfdc";
	foreground = "#333023";
      };
    };
  };

  # Change dconf settings just in case
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

  };



  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Multiple jdks on system
    "jdks/jdk8".source = pkgs.zulu8;
    "jdks/jdk17".source = pkgs.zulu17;
    "jdks/jdk".source = pkgs.zulu;

    ".oh-my-zsh/custom/themes/lambdaf.zsh-theme".text = customOhMyZshTheme;
    ".local/share/icons/hicolor/256x256/apps/vesktop.png".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Vencord/Vesktop/refs/heads/main/static/icon.png";
      sha256 = "087r0fr6crj1m9248lj70b2ppmh33lnh8szgjyjm2jv229k7rm0j";
    };

    "default/assets" = {
      source = ./ags/config/style/assets;
      recursive = true;
    };

    "default/shell.nix".text = ''
{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  # pkgs.hello
  packages = [ ];
}'';

    "default/window-icon.svg".text = ''<svg width="23px" height="20px" viewBox="-1 0 22 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <!-- Generator: Sketch 3.8.1 (29687) - http://www.bohemiancoding.com/sketch -->
    <title>window_plus [#1463]</title>
    <desc>Created with Sketch.</desc>
    <defs></defs>
    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
	<g id="Dribbble-Light-Preview" transform="translate(-339.000000, -440.000000)" fill="#c0caf5">
	    <g id="icons" transform="translate(56.000000, 160.000000)">
		<path d="M302.95,282 L301.9,282 L301.9,281 C301.9,280.448 301.4296,280 300.85,280 C300.2704,280 299.8,280.448 299.8,281 L299.8,282 L298.75,282 C298.1704,282 297.7,282.448 297.7,283 C297.7,283.552 298.1704,284 298.75,284 L299.8,284 L299.8,285 C299.8,285.552 300.2704,286 300.85,286 C301.4296,286 301.9,285.552 301.9,285 L301.9,284 L302.95,284 C303.5296,284 304,283.552 304,283 C304,282.448 303.5296,282 302.95,282 M301.9,289.064 L301.9,298.064 L301.9,298.127 C301.9,299.197 301.05895,300 299.93545,300 L299.87035,300 L285.17035,300 L285.1042,300 C283.9807,300 283,299.197 283,298.127 L283,298.064 L283,284.002 C283,282.932 283.9807,282 285.1042,282 L294.62035,282 C295.19995,282 295.6,282.464 295.6,283.016 L295.6,283.032 C295.6,283.584 295.19995,284 294.62035,284 L286.22035,284 C285.6397,284 285.1,284.512 285.1,285.064 L285.1,297.064 C285.1,297.617 285.6397,298 286.22035,298 L298.82035,298 C299.39995,298 299.8,297.617 299.8,297.064 L299.8,289.064 C299.8,288.512 300.2872,288 300.86785,288 L300.88465,288 C301.4653,288 301.9,288.512 301.9,289.064" id="window_plus-[#1463]"></path>
	    </g>
	</g>
    </g>
</svg>'';
  };


  home.sessionVariables = {
    # EDITOR = "nvim";
  };
  home.sessionPath = [
    "$HOME/jdks/jdk/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
