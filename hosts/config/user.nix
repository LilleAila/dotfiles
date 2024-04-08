{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.user = {
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

  config = with config.settings.user; {
    # TODO: Set users.users.user.name = ${name} instead of users.users."${name}"?
    users.users."${name}" = {
      isNormalUser = true;
      description = desc;
      extraGroups = ["wheel" "input"];
      packages = with pkgs; [];
      shell = shell;
      # initialPassword = "";
    };

    nix.settings.trusted-users = [
      "@wheel"
      config.settings.user.name
    ];
  };
}
