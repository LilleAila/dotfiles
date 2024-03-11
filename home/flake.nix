{
  description = "Home Manager configuration of olai";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		########## Hyprland
		hyprland.url = "github:hyprwm/Hyprland";

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

		########## Other
		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-colors.url = "github:misterio77/nix-colors";

		nix-index-database.url = "github:Mic92/nix-index-database";
		nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

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

		########## Emacs
		flake-utils.url = "github:numtide/flake-utils";
		emacs-overlay = {
			url = "github:nix-community/emacs-overlay";
			inputs.flake-utils.follows = "flake-utils";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		wrapper-manager = {
			url = "github:viperML/wrapper-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# eaf = {
		# 	url = "github:emacs-eaf/emacs-application-framework";
		# 	flake = false;
		# };
  };

  outputs = { nixpkgs, home-manager, nix-index-database, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
			# nixpkgs.overlays = [ ( import inputs.emacs-overlay ) ];

      homeConfigurations."olai" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

				extraSpecialArgs = { inherit inputs; };

        modules = [
					({ nixpkgs.overlays = [ inputs.emacs-overlay.overlay ]; })
					./home.nix
					nix-index-database.hmModules.nix-index
				];
      };
    };
}
