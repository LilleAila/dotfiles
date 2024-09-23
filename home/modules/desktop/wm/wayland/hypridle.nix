{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
# let
#   # I'm dumb - you can just use the idleinhibit windowrule
#   = command:
#     lib.getExe (pkgs.writeShellScriptBin "suspend-script" ''
#       #!/usr/bin/env bash
#       if ! ${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} clients | ${lib.getExe pkgs.ripgrep} -iq '${lib.concatStringsSep "|" config.settings.wm.hypridle.inhibit}'; then
#         ${command}
#       fi
#     '');
# in
{
  options.settings.wm.hypridle.enable = lib.mkEnableOption "hypridle";
  # options.settings.wm.hypridle.inhibit = lib.mkOption {
  #   type = lib.types.listOf lib.types.str;
  #   default = [];
  # };

  config = lib.mkIf config.settings.wm.hypridle.enable {
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
      settings =
        let
          hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
          loginctl = lib.getExe' pkgs.systemd "loginctl";
          systemctl = lib.getExe' pkgs.systemd "systemctl";
          swaylock = lib.getExe config.programs.swaylock.package;
        in
        rec {
          general = {
            before_sleep_cmd = "${loginctl} lock-session";
            lock_cmd = "pidof swaylock || ${swaylock}";
            after_sleep_cmd = "${hyprctl} dispatch dpms on";
            ignore_dbus_inhibit = false;
          };

          /*
            TODO have these listeners in this order:
            1. dim screen (brightnessctl)
            2. turn off screen (hyprctl dpms)
            3. suspend (systemctl, also fix the before_sleep_cmd to actually run on suspend)
          */
          listener = [
            {
              timeout = 300;
              on-timeout = general.lock_cmd;
            }
            {
              timeout = 600;
              on-timeout = "${hyprctl} dispatch dpms off";
              on-resume = "${hyprctl} dispatch dpms on";
            }
            {
              timeout = 660;
              on-timeout = "${systemctl} suspend";
            }
          ];
        };
    };
  };
}
