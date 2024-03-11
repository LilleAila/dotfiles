{
  description = "NixOS config flake";

	inputs = {
		# nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		# Temporarily using old nixpkgs version, because of tpwrules/nixos-apple-silicon #174
		nixpkgs.url = "github:nixos/nixpkgs/e9631b9779c8db9cd5ea537b2336926137b1826f";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# === Hardware ===
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		nixos-apple-silicon = {
			url = "github:tpwrules/nixos-apple-silicon";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# # === Hyprland ===
		# hyprland.url = "github:hyprwm/Hyprland";
		# hyprland.inputs.nixpkgs.follows = "nixpkgs";
	};

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      # system = "x86_64-linux";
			system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
				m1pro14 = nixpkgs.lib.nixosSystem {
					inherit system;
					modules = [
						({ nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.apple-silicon-overlay ]; })
						inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
						./hosts/m1pro14/configuration.nix
						home-manager.nixosModules.home-manager {
							home-manager = {
								useUserPackages = true;
								useGlobalPkgs = true;
								users.olai = ./home/home.nix;
							};
						}
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
