{
  description = "NixOS config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		# home-manager = {
		# 	url = "github:nix-community/home-manager";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
				t420 = nixpkgs.lib.nixosSystem {
					inherit system;
					modules = [
						./hosts/t420/configuration.nix
					];
				};
        legion = nixpkgs.lib.nixosSystem {
					inherit system;
          modules = [
            ./hosts/legion/configuration.nix
						# home-manager.nixosModules.home-manager
						# {
						# 	home-manager = {
						# 		useUserPackages = true;
						# 		useGlobalPkgs = true;
						# 		users.olai = ./home/home.nix;
						# 	};
						# }
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
