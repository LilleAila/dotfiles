{
  self,
  inputs,
  lib,
  config,
  ...
}:
{
  options.configurations = {
    nixos = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            module = lib.mkOption {
              type = lib.types.deferredModule;
              default = { };
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = "olai";
            };
          };
        }
      );
      default = { };
    };

    darwin = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            module = lib.mkOption {
              type = lib.types.deferredModule;
              default = { };
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = "olaisolsvik";
            };
          };
        }
      );
      default = { };
    };

    home = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          { config, ... }:
          {
            options = {
              module = lib.mkOption {
                type = lib.types.deferredModule;
                default = { };
              };
              user = lib.mkOption {
                type = lib.types.str;
                default = "olai";
              };
              homeDirectory = lib.mkOption {
                type = lib.types.str;
                default = "/home/${config.user}";
              };
              system = lib.mkOption {
                type = lib.types.str;
                default = "x86_64-linux";
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config.flake = {
    modules.homeManager.init = {
      home.stateVersion = "23.11";
    };

    modules.nixos.home =
      { user, ... }:
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager

          (lib.mkAliasOptionModule
            [ "hm" ]
            [
              "home-manager"
              "users"
              user
            ]
          )
        ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          users.${user}.imports = (builtins.attrValues self.modules.homeManager) ++ [
            {
              home = {
                homeDirectory = lib.mkForce "/home/${user}";
                username = user;
              };
            }
          ];
        };
      };

    modules.darwin.home =
      { user, ... }:
      {
        imports = [
          inputs.home-manager.darwinModules.home-manager

          (lib.mkAliasOptionModule
            [ "hm" ]
            [
              "home-manager"
              "users"
              user
            ]
          )
        ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          users.${user}.imports = (builtins.attrValues self.modules.homeManager) ++ [
            {
              home = {
                homeDirectory = lib.mkForce "/Users/${user}";
                username = user;
              };
            }
          ];
        };
      };

    nixosConfigurations = lib.mapAttrs (
      _: cfg:
      lib.nixosSystem {
        modules = [
          cfg.module
          { _module.args.user = cfg.user; }
        ]
        ++ builtins.attrValues self.modules.nixos;
      }
    ) config.configurations.nixos;

    darwinConfigurations = lib.mapAttrs (
      _: cfg:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          cfg.module
          { _module.args.user = cfg.user; }
        ]
        ++ builtins.attrValues self.modules.darwin;
      }
    ) config.configurations.darwin;

    homeConfigurations = lib.mapAttrs (
      _: cfg:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs { inherit (cfg) system; };
        modules = [
          cfg.module
          {
            _module.args.user = cfg.user;
            home = {
              homeDirectory = lib.mkForce cfg.homeDirectory;
              username = cfg.user;
            };
          }
        ]
        ++ builtins.attrValues self.modules.homeManager;
      }
    ) config.configurations.home;

    checks =
      (
        (
          config.flake.nixosConfigurations
          |> lib.mapAttrsToList (
            name: cfg: {
              ${cfg.config.nixpkgs.hostPlatform.system} = {
                "configurations:nixos:${name}" = cfg.config.system.build.toplevel;
              };
            }
          )
        )
        ++ (
          config.flake.darwinConfigurations
          |> lib.mapAttrsToList (
            name: cfg: {
              ${cfg.config.nixpkgs.hostPlatform.system} = {
                "configurations:darwin:${name}" = cfg.config.system.build.toplevel;
              };
            }
          )
        )
        ++ (
          config.flake.homeConfigurations
          |> lib.mapAttrsToList (
            name: cfg: {
              ${cfg.pkgs.stdenv.hostPlatform.system} = {
                "configurations:home:${name}" = cfg.config.home.activationPackage;
              };
            }
          )
        )
      )
      |> lib.mkMerge;
  };
}
