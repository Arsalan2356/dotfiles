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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix.url = "github:danth/stylix";

    ags.url = "github:Aylur/ags/67b0e31ded361934d78bddcfc01f8c3fcf781aad";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-custom = {
      url = "github:Arsalan2356/nixpkgs/custom";
    };

    zen-twilight = {
      url = "github:Arsalan2356/zen-twilight-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";

    nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # nix-proton-cachyos.url = "github:jbgi/nix-proton-cachyos";


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
	  inputs.aagl.nixosModules.default
	  inputs.flatpaks.nixosModules.declarative-flatpak
	  inputs.nyx.nixosModules.default
	];
      };
    };
  };
}

