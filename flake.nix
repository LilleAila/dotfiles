{
  description = "NixOS config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		# home-manager = {
		# 	url = "github:nix-community/home-manager";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
	};

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
				m1pro14 = nixpkgs.lib.nixosSystem {
					inherit system;
					modules = [
						./hosts/m1pro14/configuration.nix
					];
				};
				t420 = nixpkgs.lib.nixosSystem {
					inherit system;
					modules = [
						nixos-hardware.nixosModules.lenovo-thinkpad-t420
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
