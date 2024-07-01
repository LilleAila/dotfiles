{
  pkgs,
  inputs,
  lib,
  config,
  outputs,
  ...
}:
{
  options.settings.plymouth.enable = lib.mkEnableOption "plymouth";

  config = lib.mkIf config.settings.plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "nix-colors";
      themePackages = [
        (outputs.packages.${pkgs.system}.plymouth-theme.override { inherit (config.hm) colorScheme; })
      ];
    };
  };
}
