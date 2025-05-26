# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, lib, config, pkgs, system, ... }:
let
  csystem = system;
in {
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.custom-packages
      outputs.overlays.master-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./custom
    ];

  # Set swappiness
  boot.kernel.sysctl = { "vm.swappiness" = 134; };

  # Kernel Packages
  # Switch to zen kernel (latest from fork)
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs-custom.linuxPackages_zen;
  # boot.kernelPackages = inputs.nyx.legacyPackages.${csystem}.linuxPackages_cachyos;


  # Load amdgpu kernel module
  # boot.initrd.kernelModules = [ "amdgpu" ];

  # boot.kernelParams = [ "mitigations=off" ];

  # Load nvidia kernel module
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelParams = [ "module_blacklist=amdgpu" "mitigations=off" ];


  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 6;

  # Store docs on system
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
    extraPackages = with pkgs.unstable; [
      # rocmPackages.clr.icd
      nvidia-vaapi-driver
    ];
  };

  # Enable Nvidia Drivers
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
  };


  # Set your time zone.
  # time.timeZone = "America/New_York";
  time.timeZone = "Asia/Dubai";

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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "input" "gamemode" ];
    useDefaultShell = true;
    shell = pkgs.unstable.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs.unstable; [

    # General Purpose
    vim
    foot
    gparted
    pavucontrol
    lxqt.lxqt-policykit
    appimage-run
    rsync
    busybox
    btop
    papirus-icon-theme
    man-pages
    man-pages-posix
    parsec-bin

    # Hyprland specific
    nwg-displays
    networkmanagerapplet
    wlogout
    hyprcursor
    xcur2png
    hyprpolkitagent
    # egl-wayland

    # Browser
    inputs.zen-twilight.packages.${csystem}.zen-browser


    # Rebind Caps Lock
    input-remapper


    # Useful KDE Packages
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.kolourpaint
    kdePackages.xwaylandvideobridge
    kdePackages.gwenview


    (python312.withPackages (python-pkgs: [
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
      python-pkgs.scikit-learn
      python-pkgs.seaborn
      python-pkgs.tensorflow-bin
      python-pkgs.torch
      python-pkgs.cvxpy
      python-pkgs.python-lsp-server
    ]))

    # Dev Packages
    valgrind
    kdbg
    gnumake
    gcc14
    gdb
    scanmem
    git-lfs
    nix-prefetch-git


    # Installing wine here doesn't give conflicts for some reason
    wineWowPackages.stagingFull


    # for thunar
    gvfs
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


    (import ./ags { pkgs = pkgs.unstable; })
  ];
  # Add dev outputs from packages as well (for development packages)
  environment.extraOutputsToInstall = [ "dev" ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [
	"Hack"
  ];

  fonts.packages = with pkgs.unstable; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    cantarell-fonts
    noto-fonts
    noto-fonts-cjk-sans
  ];



  # Enable flakes
  nix = {
    package = pkgs.unstable.nix;
    extraOptions = "
      experimental-features = nix-command flakes
      trusted-users = root rc
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    ";
  };

  # Set performance mode
  powerManagement.cpuFreqGovernor = "performance";


  # Security
  security.polkit.enable = true;
  security.rtkit.enable = true;


  # Udisks
  services.udisks2.enable = true;

  # Enable greetd for tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
	command = "${pkgs.unstable.greetd.tuigreet}/bin/tuigreet --asterisks --time-format \"%A %d, %B %Y\" -r --remember-session --sessions ${pkgs.master.hyprland}/share/wayland-sessions";
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
    # "amdgpu"
    "nvidia"
  ];

  # Enable zram
  services.zram-generator.enable = true;

  # Enable flatpaks and add declaratively
  services.flatpak = {
    enable = true;
    packages = [
      # Keep this around just in case
      # "flathub:app/dev.vencord.Vesktop//stable"
      # "flathub:app/com.github.tchx84.Flatseal//stable"
    ];
    remotes = {
    "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
  };

  services.irqbalance.enable = true;
  # Fix irq#308 (wait for new release to remove)
  systemd.services.irqbalance.serviceConfig.ProtectKernelTunables = "no";


  services.tumbler.enable = true;
  services.gvfs.enable = true;


  # Start input-remapper on startup with a delay
  systemd.services.input-remapper-sudo = {
    enable = true;
    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStartPre = "${pkgs.unstable.coreutils-full}/bin/sleep 3";
      ExecStart = "${pkgs.unstable.sudo}/bin/sudo ${pkgs.unstable.input-remapper}/bin/input-remapper-service";
    };
  };

  systemd.services.systemd-vconsole-setup.unitConfig.After = "local-fs.target";


  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.unstable.xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };


  # Enable Zsh (config in home.nix)
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;


  # Enable dconf
  programs.dconf.enable = true;


  # Enable hyprland
  programs.hyprland.enable = true;
  programs.hyprland.portalPackage = pkgs.master.xdg-desktop-portal-hyprland;

  # Enable steam
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    extest.enable = true;
    protontricks.enable = true;
    # extraCompatPackages = [
    #   inputs.nix-proton-cachyos.packages.${csystem}.proton-cachyos
    # ];
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Gamemode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  # Git
  programs.git.enable = true;

  # htop (just in case btop doesn't work)
  programs.htop.enable = true;


  # nh for system cleaning
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

  # Lazygit (Git TUI)
  programs.lazygit.enable = true;

  # Fixes unpatched packages
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs.unstable; [
      stdenv.cc.cc
    ];
  };

  # ssh auth
  programs.ssh.startAgent = true;


  # Enable executing appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Use thunar file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.unstable.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  # Xwayland
  programs.xwayland.enable = true;

  # Virt-Manager
  programs.virt-manager.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;

  # VM
  virtualisation.libvirtd.enable = true;


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
