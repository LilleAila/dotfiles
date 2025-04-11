{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.kdeconnect.enable = lib.mkEnableOption "kdeconnect";

  config = lib.mkIf config.settings.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    settings.persist.home.cache = [
      ".config/kdeconnect"
      ".cache/kdeconnect-settings"
    ];
  };
}
