{
  description = "NixOS config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
					inherit system;
          modules = [
            ./nixos/configuration.nix
						home-manager.nixosModules.home-manager
						{
							home-manager = {
								useUserPackages = true;
								useGlobalPkgs = true;
								users.olai = ./home/home.nix;
							};
						}
          ];
        };
      };
      # homeConfigurations = {
      #   olai = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [
      #       ./home/home.nix
      #     ];
      #   };
      # };
    };
}
