{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  user = config.settings.user.name;
  cfg = config.settings.persist;
  hmCfg = config.hm.settings.persist;
in {
  options.settings.impermanence.enable = lib.mkEnableOption "impermanence";

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./nixos.nix
    ./hm.nix
  ];

  config = lib.mkIf config.settings.impermanence.enable {
    sops.age.keyFile = "/persist/cache/home/${config.settings.user.name}/.config/sops/age/keys.txt";
    settings.persist.home.cache = [".config/sops/age"];
    # With impermanence, the file can not be managed by nix
    hm.home.file.".config/sops/age/keys.txt".enable = false;

    boot.tmp.cleanOnBoot = true;

    fileSystems."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "size=1G"
        "mode=755"
      ];
    };

    security.sudo.extraConfig = "Defaults lecture=never";

    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        files = ["/etc/machine-id"] ++ cfg.root.files;
        directories = ["/var/log"] ++ cfg.root.directories;

        users.${user} = {
          files = cfg.home.files ++ hmCfg.home.files;
          directories =
            [
              "devel"
              "dotfiles"
            ]
            ++ cfg.home.directories
            ++ hmCfg.home.directories;
        };
      };

      "/persist/cache" = {
        hideMounts = true;
        files = cfg.root.cache_files;
        directories = ["/var/lib/systemd/backlight"] ++ cfg.root.cache;

        users.${user} = {
          directories = hmCfg.home.cache ++ cfg.home.cache;
          files = hmCfg.home.cache_files;
        };
      };
    };
  };
}
