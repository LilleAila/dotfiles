{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.user = {
    enable = lib.mkDisableOption "configure user account";
    name = lib.mkOption {
      type = lib.types.str;
    };
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
      w: !(lib.strings.hasInfix "The options silently discard others by the order of precedence" w)
    );
  };

  config = lib.mkIf config.settings.user.enable (with config.settings.user; {
    users.users."${name}" = {
      isNormalUser = true;
      uid = 1000;
      gid = 100;
      description = desc;
      extraGroups = ["wheel" "input" "dialout"];
      packages = with pkgs; [];
      shell = shell;
      initialPassword = "";
    };

    environment.shells = [config.settings.user.shell];

    nix.settings.trusted-users = [
      "@wheel"
      config.settings.user.name
    ];
  });
}
