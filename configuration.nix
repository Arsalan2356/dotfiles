# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:
let
  themes = pkgs.callPackage ./theme.nix {};
  tokyonight = pkgs.tokyonight-gtk-theme.overrideAttrs (old : {
    src = pkgs.fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Tokyonight-GTK-Theme";
      rev = "4dc45d60bf35f50ebd9ee41f16ab63783f80dd64";
      hash = "sha256-AKZA+WCcfxDeNrNrq3XYw+SFoWd1VV2T9+CwK2y6+jA=";
    };
  });
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.aagl.nixosModules.default
    ];

  # Kernel Packages
  # Switch to latest
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;


  # Load amdgpu kernel module
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Load nvidia kernel module
  # boot.initrd.kernelModules = [ "nvidia" ];
  # boot.kernelParams = [ "module_blacklist=amdgpu" ];



  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 6;


  documentation = {
    enable = true;
    nixos.enable = true;
    man = {
      enable = true;
      mandoc.enable = true;
      man-db.enable = false;
    };
    dev.enable = true;
  };


  # Add in other fileSystems
  fileSystems."/mnt/H" =
    { device = "/dev/disk/by-label/ssd";
      # change to ntfs if windows
      fsType = "ext4";
      options = [ "relatime" ];
    };
  fileSystems."/mnt/D" =
    { device = "/dev/disk/by-label/hdd";
      fsType = "ext4";
      options = [ "relatime" ];
    };
  fileSystems."/mnt/G" =
    { device = "/dev/disk/by-label/bhdd";
      fsType = "ext4";
      options = [ "relatime" ];
    };

  # Define your hostname.
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    general = {
      ControllerMode = "dual";
    };
  };

  # Enable AMD Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };


  # Enable Nvidia Drivers

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rc = {
    isNormalUser = true;
    description = "rc";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "input" ];
    useDefaultShell = true;
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # General Purpose
    vim
    kitty
    gparted
    parted
    pavucontrol
    lxqt.lxqt-policykit
    walker
    conky
    appimage-run
    rsync
    nix-search-cli
    busybox
    btop
    papirus-icon-theme
    tokyonight
    man-pages
    man-pages-posix

    # graphene
    # libsigcxx
    # pkg-config
    # sass
    # cairo
    # cairomm
    # # GTK Stuff
    # glib
    # glibmm
    # pango
    # pangomm
    # gdk-pixbuf
    # atkmm
    # gobject-introspection
    # libepoxy
    # gtk4
    # gtk4-layer-shell
    # # Dependencies
    # autoconf
    # automake
    # bison
    # debugedit
    # fakeroot
    # file
    # flex
    # gettext
    # groff
    # libtool
    # gnum4


    # Hyprland specific
    nwg-displays
    networkmanagerapplet
    wlogout
    hyprcursor
    xcur2png

    # Browser
    firefox-devedition-bin


    # Rebind Caps Lock
    input-remapper


    # Useful KDE Packages
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.kolourpaint
    kdePackages.xwaylandvideobridge
    kdePackages.gwenview


    (python3Full.withPackages (python-pkgs: [
      python-pkgs.pip
      python-pkgs.pandas
      python-pkgs.numpy
      python-pkgs.requests
      python-pkgs.scipy
      python-pkgs.matplotlib
      python-pkgs.pygobject3
      python-pkgs.keyboard
      python-pkgs.pyqt6
      python-pkgs.pyqtdarktheme
    ]))

    # Dev Packages
    valgrind
    kdbg
    gnumake
    gcc14
    gdb
    scanmem


    # Installing wine here doesn't give conflicts for some reason
    wineWowPackages.staging
    wineWowPackages.waylandFull


    # Archive backends for thunar
    binutils
    bzip2
    cpio
    gzip
    lhasa
    lrzip
    lz4
    lzip
    lzop
    p7zip
    unrar
    unzip
    xz
    zip
    zstd

    # VM Stuff
    qemu
    virt-manager
    spice-gtk


    # Custom Stuff
    (pkgs.callPackage ./audiorelay.nix {})
    (import ./grimblast.nix { inherit pkgs; })
    (import ./bt.nix { inherit pkgs; })
    (import ./sysinfo.nix { inherit pkgs; })
    (import ./clients.nix { inherit pkgs; })
    (import ./clients2.nix { inherit pkgs; })
    (import ./bluetooth.nix {inherit pkgs; })
    (import ./ags {inherit pkgs; })
    (import ./iconfinder.nix { inherit lib pkgs; })
    parsec-bin
    themes.minimal


  ];
  environment.extraOutputsToInstall = [ "dev" ];

  # Fonts
  fonts.packages = with pkgs; [
	fira-code
	hack-font
	(nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
  ];

  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts.monospace = [
	"Hack"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Enable flakes
  nix = {
	package = pkgs.nix;
	extraOptions = "
		experimental-features = nix-command flakes
		trusted-users = root rc
		extra-substituters = https://devenv.cachix.org
		extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
	";
  };


  powerManagement.cpuFreqGovernor = "performance";


  # Security
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.udisks2.enable = true;

  services.input-remapper.enable = true;
  services.input-remapper.serviceWantedBy = lib.mkForce [];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
	command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --time-format \"%A %d, %B %Y\" -r --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
	user = "greeter";
      };
    };
  };


  # Add UPower
  services.upower.enable = true;
  services.cpupower-gui.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."11-bluetooth-policy" = {
	"wireplumber.settings" = {
	"bluetooth.autoswitch-to-headset-profile" = false;
	};
      };
    };
    extraConfig.pipewire = {
      context.properties = {
      default.clock.rate = 48000;
      };
    };
  };

  # Things now show up in bin properly
  services.envfs.enable = true;

  # Configure Display Server (xserver seems to be an old name)
  services.xserver.xkb = {
    layout = "us";
  };

  # Enable multiple video drivers (automatically uses the correct one)
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  services.displayManager.sddm = {
    enable = false;
    wayland.enable = true;
    autoNumlock = true;
    package = pkgs.kdePackages.sddm;
    theme = "${themes.minimal}/share/sddm/themes/where_is_my_sddm_theme";
    extraPackages = with pkgs; [
      kdePackages.qt5compat
    ];
  };


  # Enable flatpaks
  services.flatpak.enable = true;


  systemd.services.input-remapper-sudo = {
    enable = true;
    wantedBy = ["default.target"];

    serviceConfig = {
      #  ${pkgs.input-remapper}/bin/input-remapper-control --command autoload
      ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 3";
      ExecStart = "${pkgs.sudo}/bin/sudo ${pkgs.input-remapper}/bin/input-remapper-service";
    };
  };


  # XDG Portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
  ];


  # Enable Zsh (config in home.nix)
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;


  # Enable dconf
  programs.dconf.enable = true;


  # Enable hyprland
  programs.hyprland.enable = true;

  # Enable steam
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    extest.enable = true;
    protontricks.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  programs.git.enable = true;

  programs.htop.enable = true;


  programs.nh = {
    flake = "/home/flake";
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 5d --keep 5";
    };
  };

  programs.fzf.fuzzyCompletion = true;

  programs.lazygit.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
    ];
  };


  # Enable executing appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Use thunar file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  programs.xwayland.enable = true;




  programs.virt-manager.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;

  # VM
  virtualisation.libvirtd.enable = true;


  # Stylix
  # Still requires wallpaper (need to find a way to work this in with linux-wallpaperengine)
  # and randomized wallpapers from that
  # stylix = {
  #   enable = true;
  #   base16-schemes = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-storm.yaml";
  # };








  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
