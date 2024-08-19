{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options.settings.school.enable = lib.mkEnableOption "school apps";

  config = lib.mkIf config.settings.school.enable {
    home.packages = with pkgs; [
      teams-for-linux
      libreoffice
    ];
  };
}
