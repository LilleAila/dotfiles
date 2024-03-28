{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.tlp.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (config.settings.tlp.enable) {
    services.tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
        # Recalibrate with `tlp fullcharge/recalibrate`.
        # This restores charge threshold before reboot:
        RESTORE_THRESHOLDS_ON_BAT = 1;
      };
    };
  };
}
