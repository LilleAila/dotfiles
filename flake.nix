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

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
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
    # NOTE: I'm trying to make sure as few as possible instances of nixpkgs are instantiated, to improve the time and space it takes. All the top-level nixpkgs inputs are set to follow either the stable or unstable input, but i have not done anything for inputs of the inputs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # This is only used by a few things
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # i think this can be just nixpkgs with the same result
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

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
      url = "github:LilleAila/plover-flake/linux-uinput-fixed";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # emacs-overlay = {
    #   url = "github:nix-community/emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    # };

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

    # factorio-versions.url = "github:ocfox/factorio-versions";

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
      # inputs.nixpkgs.follows = "nixpkgs";
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
