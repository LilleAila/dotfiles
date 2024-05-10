{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings.wm.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.settings.wm.hypridle.enable) {
    services.hypridle = {
      enable = true;
      settings = let
        hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
        loginctl = lib.getExe' pkgs.systemd "loginctl";
        swaylock = lib.getExe config.programs.swaylock.package;
      in rec {
        general = {
          before_sleep_cmd = "${loginctl} lock-session";
          lock_cmd = "pidof swaylock || ${swaylock}";
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
          ignore_dbus_inhibit = false;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = general.lock_cmd;
          }
          {
            timeout = 600;
            on-timeout = general.before_sleep_cmd;
          }
          {
            timeout = 660;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
        ];
      };
    };
  };
}
