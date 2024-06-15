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

  imports =
    [
      inputs.impermanence.nixosModules.impermanence
    ]
    ++ lib.optionals config.settings.impermanence.enable [
      ./nixos.nix
      ./hm.nix
    ];

  config = lib.mkIf config.settings.impermanence.enable (lib.mkAssert (config.settings.zsh.enable == true) {
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
              ".cache/dconf"
              ".config/dconf"
            ]
            ++ cfg.home.directories
            ++ hmCfg.home.directories;
        };
      };

      "/persist/cache" = {
        hideMounts = true;
        directories = cfg.root.cache;

        users.${user} = {
          directories = hmCfg.home.cache;
        };
      };
    };
  });
}
