{
  description = "NixOS config flake";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nixos-apple-silicon,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib.extend (final: prev: (import ./lib final) // home-manager.lib);

      systems = lib.systems.flakeExposed;
      pkgsFor = lib.genAttrs systems (system: import nixpkgs { inherit system; });
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

      keys = import ./secrets/not-so-secrets.nix;

      defaultSettings = {
        # Define username here. Probably a better way to do this
        username = "olai";
      };

      mkConfig =
        {
          name,
          extraModules ? [ ],
          globalSettings ? defaultSettings,
        }:
        lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              self
              outputs
              globalSettings
              keys
              lib
              ;
          };
          modules = [
            ./hosts/${name}/configuration.nix
            {
              # I don't want to pass name as a specialArg
              settings.home-manager.path = ./hosts/${name}/home.nix;
            }
          ] ++ extraModules;
        };
    in
    {
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs inputs; });
      devShells = forEachSystem (pkgs: {
        default = import ./shell.nix { inherit pkgs; };
      });

      darwinConfigurations = {
        "Olais-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
          modules = [ ./hosts/m1pro-darwin/configuration.nix ];
          specialArgs = { inherit inputs outputs self; };
        };
      };

      nixosConfigurations = {
        # Desktop but nix
        nixdesktop = mkConfig { name = "desktop"; };

        x220-nix = mkConfig {
          name = "x220-nix";
          extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-t420 ];
        };

        oci-nix = mkConfig { name = "oci"; };

        t420-nix = mkConfig {
          name = "t420";
          extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-t420 ];
        };

        e14g5-nix = mkConfig {
          name = "e14g5";
          # extraModules = [nixos-hardware.nixosModules.common-cpu-amd nixos-hardware.nixosModules.common-gpu-amd];
          extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd ];
        };

        m1pro-nix = mkConfig {
          name = "m1pro";
          extraModules = [ nixos-apple-silicon.nixosModules.apple-silicon-support ];
        };

        vm-nix = mkConfig { name = "vm"; };

        installer = mkConfig {
          name = "installer";
          globalSettings.username = "nixos";
        };
      };

      homeConfigurations."${defaultSettings.username}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Idk how to do but somehow make this also arm
        extraSpecialArgs = {
          inherit inputs outputs keys;
          globalSettings = defaultSettings;
        };

        modules = [ ./home.nix ];
      };
    };

  inputs = {
    # === Important stuff ===
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    # === Other utils ===
    plover-flake = {
      url = "github:dnaq/plover-flake";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spacemacs = {
      url = "github:syl20bnr/spacemacs";
      flake = false;
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    woomer = {
      url = "github:coffeeispower/woomer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    focal = {
      url = "github:iynaix/focal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === My stuff ===
    nix-cursors = {
      url = "github:LilleAila/nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wl-screenrec-daemon = {
      url = "github:LilleAila/wl-screenrec-daemon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-config = {
      url = "github:LilleAila/nvim-nix";
      inputs.nix-colors.follows = "nix-colors";
    };

    emacs-config = {
      url = "github:LilleAila/emacs-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-colors.follows = "nix-colors";
    };

    ags-config = {
      url = "github:LilleAila/ags-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-colors.follows = "nix-colors";
    };
  };
}
