{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.user = {
    enable = lib.mkEnableOption "user configuration" // {default = true;};
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

  config = lib.mkIf config.settings.user.enable (with config.settings.user; {
    users.users."${name}" = {
      isNormalUser = true;
      description = desc;
      extraGroups = ["wheel" "input" "dialout"];
      packages = with pkgs; [];
      shell = shell;
      initialPassword = "Password123";
    };

    environment.shells = [config.settings.user.shell];

    nix.settings.trusted-users = [
      "@wheel"
      config.settings.user.name
    ];
  });
}
