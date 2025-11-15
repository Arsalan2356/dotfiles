{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix.url = "github:danth/stylix";

    ags.url = "github:Aylur/ags/67b0e31ded361934d78bddcfc01f8c3fcf781aad";

    nixpkgs-custom = {
      url = "github:Arsalan2356/nixpkgs/custom";
    };

    zen-twilight = {
      url = "github:Arsalan2356/zen-twilight-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # nix-proton-cachyos.url = "github:jbgi/nix-proton-cachyos";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    wallpaperengine-gui = {
      url = "github:Arsalan2356/wallpaperengine-gui-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = {
      rc = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs outputs system; };
	modules = [
	  ./configuration.nix
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs outputs system; };
	    home-manager.users.rc = import ./home.nix;
	  }
	  # inputs.stylix.nixosModules.stylix
	  # inputs.envfs.nixosModules.envfs
	  inputs.flatpaks.nixosModules.nix-flatpak
	  inputs.nyx.nixosModules.default
	  inputs.spicetify-nix.nixosModules.spicetify
	];
      };
    };
  };
}

