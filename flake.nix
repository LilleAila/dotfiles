{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/LilleAila/dotfiles-secrets.git";
    };

    # === Hardware ===
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Hyprland ===
    hyprland = {
      # url = "github:hyprwm/Hyprland/tags/v0.39.0";
      # url = "github:hyprwm/Hyprland?ref=v0.40.0&submodules=1";
      url = "github:hyprwm/Hyprland?ref=v0.40.0&submodules=1";
      # inputs.nixpkgs.follows = "nixpkgs"; # Disabled because cachix
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Idle inhibitor
    matcha = {
      url = "git+https://codeberg.org/QuincePie/matcha.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow/tags/v0.40.0";
      # url = "github:micha4w/Hypr-DarkWindow";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      # url = "github:VortexCoyote/hyprfocus";
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

    woomer = {
      url = "github:coffeeispower/woomer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Window Manager Related ===
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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

    # === Other utils ===
    flake-utils.url = "github:numtide/flake-utils";

    plover-flake.url = "github:LilleAila/plover-flake/wayland-support";

    nix-colors.url = "github:misterio77/nix-colors";

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    # === My stuff ===
    nix-cursors = {
      url = "github:LilleAila/nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-config = {
      # url = "/home/olai/nvim";
      url = "github:LilleAila/nvim-nix";
      # Adding the follows causes issues for some reason
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.flake-parts.follows = "flake-parts";
    };

    ags-config = {
      url = "github:LilleAila/ags-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-colors.follows = "nix-colors";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib.extend (final: prev: (import ./lib final) // home-manager.lib);

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
        }
    );
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

    keys = import ./secrets/not-so-secrets.nix;

    defaultSettings = {
      # Define username here. Probably a better way to do this
      username = "olai";
    };

    mkConfig = {
      name,
      extraModules ? [],
      globalSettings ? defaultSettings,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs globalSettings keys lib;};
        modules =
          [
            ./hosts/${name}/configuration.nix
            {
              # I don't want to pass name as a specialArg
              settings.home-manager.path = ./hosts/${name}/home.nix;
            }
          ]
          ++ extraModules;
      };
  in {
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs inputs;});
    devShells = forEachSystem (pkgs: {default = import ./shell.nix {inherit pkgs;};});

    nixosConfigurations = {
      mac-nix = mkConfig {
        name = "mac-nix";
        extraModules = [
          inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
        ];
      };

      oci-nix = mkConfig {
        name = "oci";
      };

      t420-nix = mkConfig {
        name = "t420";
        extraModules = [nixos-hardware.nixosModules.lenovo-thinkpad-t420];
      };

      legion-nix = mkConfig {
        name = "legion";
        extraModules = [nixos-hardware.nixosModules.common-cpu-intel];
      };

      e14g5-nix = mkConfig {
        name = "e14g5";
        extraModules = [nixos-hardware.nixosModules.common-cpu-amd nixos-hardware.nixosModules.common-gpu-amd];
      };

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

      modules = [
        {nixpkgs.overlays = [inputs.emacs-overlay.overlay];}
        ./home.nix
      ];
    };
  };
}
