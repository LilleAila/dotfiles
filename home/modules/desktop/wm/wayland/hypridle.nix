{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings.wm.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.settings.wm.hypridle.enable) {
    home.packages = [inputs.matcha.packages.${pkgs.system}.default];

    wayland.windowManager.hyprland.settings.exec-once = [
      # Start inhibitor daemon with inhibit disabled
      "${lib.getExe' inputs.matcha.packages.${pkgs.system}.default "matcha"} --daemon --off"
    ];

    wayland.windowManager.hyprland.settings.bindl = [
      # ", switch:on:Lid Switch, exec, ${lib.getExe' pkgs.systemd "systemctl"} suspend"
      ", switch:on:Lid Switch, exec, ${lib.getExe config.programs.swaylock.package}"
    ];

    # It no no work :(
    # systemd.user.services.swaylock = {
    #   Unit = {
    #     Description = "Lock the screen with swaylock";
    #     Before = ["suspend.target"];
    #   };
    #
    #   Service = {
    #     Type = "forking";
    #     ExecStart = "${lib.getExe config.programs.swaylock.package}";
    #     ExecStartPost = "${lib.getExe' pkgs.coreutils "sleep"} 1";
    #   };
    #
    #   Install.WantedBy = ["suspend.target"];
    # };

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
