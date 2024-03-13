{
  description = "NixOS config flake";

	inputs = {
		# TODO: wait until nixpkgs fixes u-boot
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

		# === Hyprland ===
		hyprland.url = "github:hyprwm/Hyprland";
		hyprland.inputs.nixpkgs.follows = "nixpkgs";
		
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs.hyprland.follows = "hyprland";
		};

		hyprlock = {
			url = "github:hyprwm/hyprlock";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hypridle = {
			url = "github:hyprwm/hypridle";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# === Window Manager Related ===
		flake-parts = {
			url = "github:hercules-ci/flake-parts";
			inputs.nixpkgs-lib.follows = "nixpkgs";
		};

		gross = {
			url = "github:fufexan/gross";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.flake-parts.follows = "flake-parts";
		};

		ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		# === Emacs ===
		emacs-overlay = {
			url = "github:nix-community/emacs-overlay";
			inputs.flake-utils.follows = "flake-utils";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# === Other ===
		flake-utils.url = "github:numtide/flake-utils";

		nix-colors.url = "github:misterio77/nix-colors";

		nix-index-database.url = "github:Mic92/nix-index-database";
		nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

		wrapper-manager = {
			url = "github:viperML/wrapper-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      # system = "x86_64-linux";
			system = "aarch64-linux"; # TODO: make this work for both architectures
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
				m1pro14 = nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = { inherit inputs; };
					modules = [
						({ nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.apple-silicon-overlay ]; })
						inputs.nixos-apple-silicon.nixosModules.apple-silicon-support # TODO: The apple-silicon-support (NOT FIRMWARE!!) folders are probably unnecessary
						./hosts/m1pro14/configuration.nix
						home-manager.nixosModules.home-manager {
							home-manager = {
								extraSpecialArgs = { inherit inputs; };
								useUserPackages = true;
								useGlobalPkgs = true;
								users.olai = ./home/home.nix; # TODO: different home.nix-es for each system (use lib.xxx options, with a "control-panel" in each home.nix)
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
