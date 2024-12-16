{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
	url = "github:nixos/nixpkgs/nixos-unstable";
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

    nixpkgs-test = {
      url = "github:Arsalan2356/nixpkgs/custom";
    };


  };
  outputs = inputs @ { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-test = import inputs.nixpkgs-test {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      rc = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit pkgs inputs pkgs-test; };
	modules = [
	  ./configuration.nix
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit pkgs inputs pkgs-test; };
	    home-manager.users.rc = import ./home.nix;
	  }
	  # inputs.stylix.nixosModules.stylix
	  # inputs.envfs.nixosModules.envfs
	];
      };
    };
  };
}

