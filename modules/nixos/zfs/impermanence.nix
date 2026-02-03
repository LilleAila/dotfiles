{ lib, inputs, ... }:
{
  flake.modules.homeManager.impermanence = {
    options.settings.persist = {
      home = {
        directories = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = "Directories to persist in home directory";
        };
        files = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = "Files to persist in home directory";
        };
        cache = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = "Directories to persist, but not to snapshot";
        };
        cache_files = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = "Files to persist in home directory, but not to snapshot";
        };
      };
    };
  };

  flake.modules.nixos.impermanence =
    {
      pkgs,
      config,
      user,
      ...
    }:
    let
      cfg = config.settings.persist;
      hmCfg = config.hm.settings.persist;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.settings.impermanence.enable = lib.mkEnableOption "impermanence";

      options.settings.persist = {
        root = {
          directories = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Directories to persist in root filesystem";
          };
          files = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Files to persist in root filesystem";
          };
          cache = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Directories to persist, but not to snapshot";
          };
          cache_files = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Files to persist in root filesystem, but not to snapshot";
          };
        };
        home = {
          directories = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Directories to persist in home directory";
          };
          files = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Files to persist in home directory";
          };
          cache = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Files to persist in home directory, but not to snapshot";
          };
        };
      };

      config = lib.mkIf config.settings.impermanence.enable {
        sops.age.keyFile = "/persist/cache/home/${user}/.config/sops/age/keys.txt";
        settings.persist.home.cache = [ ".config/sops/age" ];
        settings.persist.home.directories = [
          "devel"
          "dotfiles"
        ];
        # With impermanence, the file can not be managed by nix
        hm.home.file.".config/sops/age/keys.txt".enable = false;

        boot.tmp.cleanOnBoot = true;

        fileSystems."/" = {
          device = "tmpfs";
          fsType = "tmpfs";
          neededForBoot = true;
          options = [
            "defaults"
            "size=2G"
            "mode=755"
          ];
        };

        security.sudo.extraConfig = "Defaults lecture=never";

        environment.persistence = {
          "/persist" = {
            hideMounts = true;
            inherit (cfg.root) files;
            directories = [ "/var/log" ] ++ cfg.root.directories;

            users.${user} = {
              files = cfg.home.files ++ hmCfg.home.files;
              directories = cfg.home.directories ++ hmCfg.home.directories;
            };
          };

          "/persist/cache" = {
            hideMounts = true;
            files = cfg.root.cache_files;
            directories = [ "/var/lib/systemd/backlight" ] ++ cfg.root.cache;

            users.${user} = {
              directories = hmCfg.home.cache ++ cfg.home.cache;
              files = hmCfg.home.cache_files;
            };
          };
        };
      };
    };
}
