{ config, lib, ... }:
{
  config = {
    flake.modules.darwin.user =
      { user, ... }:
      {
        system.primaryUser = user;
      };

    flake.modules.nixos.user =
      { user, pkgs, ... }:
      {
        options.settings.user = {
          enable = lib.mkDisableOption "configure user account";
          desc = lib.mkOption {
            type = lib.types.str;
            default = config.settings.user.name;
            description = "User description";
          };
          shell = lib.mkOption {
            type = lib.types.package;
            default = pkgs.zsh;
          };
        };

        config = with config.settings.user; {
          users.users.${user} = {
            isNormalUser = true;
            uid = 1000;
            description = desc;
            extraGroups = [
              "wheel"
              "input"
              "dialout"
            ];
            packages = with pkgs; [ ];
            inherit shell;
            initialPassword = "";
          };

          users.groups.users.gid = 100;

          environment.shells = [ shell ];

          nix.settings.trusted-users = [
            "@wheel"
            config.settings.user.name
          ];
        };
      };
  };
}
