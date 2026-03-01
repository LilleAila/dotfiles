{
  self,
  lib,
  ...
}:
{
  flake.modules.darwin.user =
    { user, ... }:
    {
      system.primaryUser = user;
    };

  flake.modules.nixos.user =
    {
      config,
      user,
      pkgs,
      ...
    }:
    {
      options.settings.user = {
        enable = self.lib.mkDisableOption "configure user account";
        desc = lib.mkOption {
          type = lib.types.str;
          default = user;
          description = "User description";
        };
        shell = lib.mkOption {
          type = lib.types.package;
          default = pkgs.zsh;
        };
      };

      # silence warning about setting multiple user password options
      # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
      options.warnings = lib.mkOption {
        apply = lib.filter (
          w: !(lib.strings.hasInfix "If multiple of these password options are set at the same time" w)
        );
      };

      imports = [
        (lib.mkAliasOptionModule [ "user" ] [ "users" "users" user ])
      ];

      config = with config.settings.user; {
        settings.persist.root.directories = [ "/var/lib/nixos" ];

        user = {
          inherit shell;
          isNormalUser = true;
          uid = 1000;
          description = desc;
          extraGroups = [
            "wheel"
            "input"
            "dialout"
            "cdrom"
          ];
          packages = with pkgs; [ ];
          initialPassword = "";
        };

        users.groups.users.gid = 100;

        environment.shells = [ shell ];

        nix.settings.trusted-users = [
          "@wheel"
          user
        ];
      };
    };
}
