{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
    hyprland = {
      # url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # url = "github:hyprwm/Hyprland/tags/v0.39.0";
      url = "github:hyprwm/Hyprland?ref=v0.40.0&submodules=1";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

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

    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow/tags/v0.39.0";
      # url = "github:micha4w/Hypr-DarkWindow";
      inputs.hyprland.follows = "hyprland";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      # url = "github:VortexCoyote/hyprfocus";
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
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

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cursors = {
      url = "github:LilleAila/nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === Neovim configuration ===
    nixvim-config = {
      # url = "/home/olai/nvim";
      url = "github:LilleAila/nvim-nix";
      # Adding the follows causes issues for some reason
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.flake-parts.follows = "flake-parts";
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
    lib = nixpkgs.lib // home-manager.lib;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
        }
    );

    globalSettings = {
      # Define username here. Probably a better way to do this
      username = "olai";
    };
    mkConfig = {
      name,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs globalSettings;};
        modules =
          [
            ./hosts/${name}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs globalSettings;
                  isNixOS = true;
                };
                useUserPackages = true;
                useGlobalPkgs = true;
                users."${globalSettings.username}" = ./home/${name}.nix;
              };
            }
            (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" globalSettings.username])
          ]
          ++ extraModules;
      };
  in {
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});

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
    };

    homeConfigurations."${globalSettings.username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Idk how to do but somehow make this also arm
      extraSpecialArgs = {
        inherit inputs outputs globalSettings;
      };

      modules = [
        {nixpkgs.overlays = [inputs.emacs-overlay.overlay];}
        ./home.nix
      ];
    };
  };
}
