{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix.url = "github:danth/stylix";

    nixpkgs-custom = {
      url = "github:Arsalan2356/nixpkgs/nixos-26.05";
    };

    zen-twilight = {
      url = "github:Arsalan2356/zen-twilight-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    cachy-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    wallpaperengine-gui = {
      url = "github:Arsalan2356/wallpaperengine-gui-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    proton-cachyos = {
      url = "github:Arsalan2356/proton-cachyos-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comfyui-nix = {
      url = "github:utensils/comfyui-nix";
    };

    flake-input-patcher.url = "github:jfly/flake-input-patcher";
  };
  outputs = unpatchedInputs:
  let
    system = "x86_64-linux";

    patcher = unpatchedInputs.flake-input-patcher.lib.x86_64-linux;

    inputs = patcher.patch {
      inherit unpatchedInputs;
      flakePath = ./.;
      patchSpec = {
	# Patching a direct dependency:
	cachy-kernel.patches = [
	  (patcher.fetchpatch {
	    name = "cachy-kernel: remove binary cache";
	    url = "https://raw.githubusercontent.com/Arsalan2356/cachy-kernel-patches/refs/heads/master/remove-binary-caches.patch";
	    hash = "sha256-mx/IWBHaeIXTFyluxNj78Efh9OfSH/c4hmXFsgJXkYA=";
	  })
	];
      };
    };
  in rec {
    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = {
      rc = inputs.nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs overlays system; };
	modules = [
	  ./configuration.nix
	  inputs.home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs system; };
	    home-manager.users.rc = import ./home.nix;
	  }
	  # inputs.stylix.nixosModules.stylix
	  # inputs.envfs.nixosModules.envfs
	  inputs.flatpaks.nixosModules.nix-flatpak
	  inputs.spicetify-nix.nixosModules.spicetify
	  inputs.comfyui-nix.nixosModules.default
	];
      };
    };
  };
}

