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

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
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
      username = "olai";
    };
  in {
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});

    # TODO: split into multiple files, and maybe a helper function too
    nixosConfigurations = {
      mac-nix = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs outputs globalSettings;
        };
        modules = [
          {nixpkgs.overlays = [inputs.nixos-apple-silicon.overlays.apple-silicon-overlay];}
          inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
          ./hosts/mac-nix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs outputs globalSettings;
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users."${globalSettings.username}" = ./home/mac-nix.nix;
            };
          }
        ];
      };

      oci = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs outputs globalSettings;
        };
        modules = [
          ./hosts/oci/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs outputs globalSettings;
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users."${globalSettings.username}" = ./home/oci.nix;
            };
          }
        ];
      };

      pi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs outputs globalSettings;
        };
        modules = [
          ./hosts/pi4/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs outputs globalSettings;
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users."${globalSettings.username}" = ./home/pi4.nix;
            };
          }
        ];
      };

      t420-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs globalSettings;
        };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t420
          ./hosts/t420/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs outputs globalSettings;
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users."${globalSettings.username}" = ./home/t420.nix;
            };
          }
        ];
      };

      legion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs globalSettings;
        };
        modules = [
          ./hosts/legion/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs outputs globalSettings;
              };
              useUserPackages = true;
              useGlobalPkgs = true;
              users."${globalSettings.username}" = ./home/legion.nix;
            };
          }
        ];
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
