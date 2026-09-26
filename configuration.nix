# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, lib, config, pkgs, system, ... }:
let
  csystem = system;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
  kernelPkg = pkgs.linuxKernel.packagesFor (
    pkgs.cachyosKernels.linux-cachyos-latest.override rec {
      pname = "linux-cachyos-latest-${cpusched}-lto-${lto}-opt-${processorOpt}";
      cpusched = "bore";
      lto = "full";
      bbr3 = true;
      processorOpt = "native";
    }
  );
in {
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.custom-packages
      outputs.overlays.master-packages
      inputs.cachy-kernel.overlays.default
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
  boot.kernelPackages = kernelPkg;

  # Disable GUD until cachyos 7.3
  boot.kernelPatches = [
    {
      name = "disable-drm-gud";
      patch = null;
      structuredExtraConfig = {
	DRM_GUD = lib.kernel.no;
      };
    }
  ];


  # Load amdgpu kernel module
  boot.initrd.kernelModules = [ "amdgpu" ];
  #
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Load nvidia kernel module
  # boot.initrd.kernelModules = [ "nvidia" ];
  # boot.kernelParams = [ "module_blacklist=amdgpu" "usbcore.autosuspend=-1" ];

  boot.kernelModules = [ "ntsync" ];


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
      options = [ "relatime" "nofail" ];
    };
  fileSystems."/mnt/D" =
    { device = "/dev/disk/by-label/hdd";
      fsType = "ext4";
      options = [ "relatime" "nofail" ];
    };
  fileSystems."/mnt/G" =
   { device = "/dev/disk/by-label/bhdd";
     fsType = "ext4";
     options = [ "relatime" "nofail" ];
   };
  fileSystems."/export/Media/Movies" =
   { device = "/mnt/G/Plex/Media/Movies";
     depends = [
     "/mnt/G"
     ];
     fsType = "none";
     options = [ "bind" ];
   };
  fileSystems."/export/Media/TV" =
   { device = "/mnt/G/Plex/Media/TV";
     depends = [
     "/mnt/G"
     ];
     fsType = "none";
     options = [ "bind" ];
   };

  # Define your hostname.
  networking.hostName = "nixos";
  networking.extraHosts = "0.0.0.0 paradise-s1.battleye.com
0.0.0.0 test-s1.battleye.com
0.0.0.0 paradiseenhanced-s1.battleye.com";

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
      rocmPackages.clr.icd
      # Nvidia specific
      # libvdpau-va-gl
      # libva-vdpau-driver
    ];
  };

  # Enable Nvidia Drivers
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = pkgs.master.linuxPackages.nvidiaPackages.production.version;
      sha256_64bit = "sha256-5CHCAuTHn1jDx/MWG75xRU67PYiTb4ggWg4yfNBMWco=";
      sha256_aarch64 = "sha256-PafStmwNMufeDp3VtpTGGCoW+53Gor/mieO1m1pI7gI=";
      openSha256 = "sha256-FWk5ra2yjz8VAxAA8GXrSoeBj/XC1BKvsKsBKR09joE=";
      settingsSha256 = "sha256-4Kxro6tvI5aX4nu2RspgyBsW+Jq3/VYjSAS5UGdzTCU=";
      persistencedSha256 = "sha256-JsMLPqJuZwAtHngsQODMsmgO7F2tVkQ2arc7fYa2bwo=";
    };
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
  };


  # Set your time zone.
  time.timeZone = "America/New_York";
  # time.timeZone = "Asia/Dubai";

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
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "gamemode" "docker" "plocate" "comfyui" ];
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
    appimage-run
    rsync
    busybox
    btop
    papirus-icon-theme
    parsec-bin
    pulseaudio
    nethogs

    # Hyprland specific
    pkgs.master.nwg-displays
    networkmanagerapplet
    wlogout
    hyprcursor
    xcur2png
    hyprpolkitagent

    # Browser
    inputs.zen-twilight.packages.${csystem}.zen-browser
    google-chrome


    # Rebind Caps Lock
    pkgs.unstable.input-remapper


    # Useful KDE Packages
    kdePackages.qtwayland
    kdePackages.qtsvg


    (python313.withPackages (python-pkgs: [
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
      python-pkgs.tensorflow
      python-pkgs.torch
      python-pkgs.cvxpy
      python-pkgs.python-lsp-server
    ]))

    # Dev Packages
    valgrind
    kdbg
    gnumake
    gcc
    gdb
    scanmem
    git-lfs
    nix-prefetch-git
    aseprite

    # Installing wine here doesn't give conflicts for some reason
    wineWow64Packages.stableFull
    winetricks

    (pkgs.writeShellScriptBin "wine64" ''
      exec ${pkgs.unstable.wineWow64Packages.stableFull}/bin/wine "$@"
    '')


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

    # Nvidia specific
    egl-wayland

    # AI
    pkgs.master.llama-cpp-vulkan
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
  powerManagement.powertop.enable = true;


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
	command = "${pkgs.unstable.tuigreet}/bin/tuigreet --asterisks --time-format \"%A %d, %B %Y\" -r --remember-session --sessions ${pkgs.unstable.hyprland}/share/wayland-sessions";
	user = "greeter";
      };
    };
  };


  # Add UPower
  services.upower.enable = true;
  services.cpupower-gui.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.unstable.plocate;
    interval = "hourly";
  };

  # Audio
  services.pipewire = {
    package = pkgs.unstable.pipewire;
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.unstable.wireplumber;
    };
    extraConfig.pipewire = {
      context.properties = {
      default.clock.rate = 48000;
      };
      extraConfig."11-bluetooth-policy" = {
	"wireplumber.settings" = {
	"bluetooth.autoswitch-to-headset-profile" = false;
	};
      };
    };
  };

  # Things now show up in bin properly
  services.envfs.enable = true;

  # Enable NFS
  services.nfs.server = {
    enable = true;
    exports = ''
    /export		    192.168.1.15(fsid=0,nohide,insecure,no_subtree_check)
    /export/Media	    192.168.1.15(fsid=0,nohide,insecure,no_subtree_check)
    /export/Media/TV	    192.168.1.15(fsid=0,nohide,insecure,no_subtree_check)
    /export/Media/Movies    192.168.1.15(fsid=0,nohide,insecure,no_subtree_check)
    '';
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };

  # Enable Plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };


  services.open-webui = {
    enable = true;
    port = 8100;
    environment = {
      OFFLINE_MODE = "true";
      HF_HUB_OFFLINE = "1";
      ANALYTICS = "False";
    };
    package = pkgs.unstable.open-webui.overrideAttrs (old: {
      propagatedBuildInputs = old.propagatedBuildInputs ++ (with pkgs.unstable.python3Packages; [requests tiktoken pyee]);
    });
  };

  services.comfyui = {
    enable = true;
    gpuSupport = "rocm";
    enableManager = true;
    port = 7860;
    dataDir = "/mnt/H/comfyui";
    extraArgs = [ "--disable-xformers" "--disable-pinned-memory" ];
  };



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
      { appId = "com.usebottles.bottles//stable"; origin = "flathub";}
      { appId = "org.gnome.Platform//46"; origin = "flathub";}
      { appId = "moe.launcher.an-anime-game-launcher"; origin = "flathub";}
    ];
    remotes = [
    { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    { name = "flathub-beta"; location = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  services.irqbalance.enable = true;
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

  systemd.services.game-index = {
    enable = true;
    wantedBy = ["default.target"];

    serviceConfig = {
      WorkingDirectory = "/home/rc/gameindex/";
      ExecStartPre = "${pkgs.unstable.coreutils-full}/bin/sleep 3";
      ExecStart = "${pkgs.bash}/bin/bash -c 'source .venv/bin/activate && python sync.py'";
    };
  };


  # XDG Portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };


  # Enable Zsh (config in home.nix)
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.unstable.zsh;
  programs.zsh.enable = true;


  # Enable dconf
  programs.dconf.enable = true;


  # Enable hyprland
  programs.hyprland.enable = true;
  programs.hyprland.portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;

  # Enable steam
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    extest.enable = true;
    protontricks.enable = true;
    protontricks.package = pkgs.unstable.protontricks;
    extraCompatPackages = [
      inputs.proton-cachyos.packages.${csystem}.default
    ];
    package = pkgs.unstable.steam.override {
      steam-unwrapped = pkgs.unstable.steam-unwrapped.overrideAttrs(final: prev: {
	postInstall = prev.postInstall + ''
	  sed -i 's|^Exec=steam |Exec=steam -console -nofriendsui |' $out/share/applications/steam.desktop
	'';
      });
    };
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

  # GPU Screen Recorder
  programs.gpu-screen-recorder.enable = true;

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
    libraries = with pkgs; [
	zlib
	zstd
	stdenv.cc.cc.lib # provides libstdc++.so and libgcc_s.so
	curl
	openssl
	attr
	libssh
	bzip2
	libxml2
	acl
	libsodium
	util-linux
	xz
	systemd
	dbus # libdbus-1.so.3
	fontconfig # libfontconfig.so.1
	freetype # libfreetype.so.6
	glib # libglib-2.0.so.0
	libGL # libGL.so.1
	libxkbcommon # libxkbcommon.so.0
	libX11 # libX11.so.6
	wayland
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
    plugins = with pkgs.unstable; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
    ];
    theme = spicePkgs.themes.text;
    colorScheme = "TokyoNight";
  };





  # Xwayland
  programs.xwayland.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;

  # 610 docker
  virtualisation.docker.enable = true;


  # Firewall for NFS
  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];


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
