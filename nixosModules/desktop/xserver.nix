{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.xserver = {
    enable = lib.mkEnableOption "xserver";
    xwayland.enable = lib.mkEnableOption "xwayland";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.xserver.enable) {
      services.xserver = {
        enable = true;

        xkb = {
          layout = "no";
          variant = "";
        };
        displayManager.lightdm.enable = false;

        updateDbusEnvironment = true;
        enableCtrlAltBackspace = true;
      };
    })
    (lib.mkIf (config.settings.xserver.xwayland.enable) {
      programs.xwayland.enable = true;
      settings.xserver.enable = true; # Also enable xserver (above)
    })
  ];
}
