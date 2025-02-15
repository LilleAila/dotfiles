{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.user = {
    enable = lib.mkDisableOption "configure user account";
    name = lib.mkOption { type = lib.types.str; };
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

  # silence warning about setting multiple user password options
  # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
  options.warnings = lib.mkOption {
    apply = lib.filter (
      w: !(lib.strings.hasInfix "If multiple of these password options are set at the same time" w)
    );
  };

  config = lib.mkIf config.settings.user.enable (
    with config.settings.user;
    {
      settings.persist.root.directories = [ "/var/lib/nixos" ];

      users.users."${name}" = {
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

      environment.shells = [ config.settings.user.shell ];

      nix.settings.trusted-users = [
        "@wheel"
        config.settings.user.name
      ];
    }
  );
}
