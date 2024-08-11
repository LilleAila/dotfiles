{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  screenrec = inputs.wl-screenrec-daemon.packages.${pkgs.system}.wl-screenrec-daemon;
in
lib.mkIf config.settings.wm.sway.enable {
  home.packages = [ screenrec ];
  wayland.windowManager.sway.config =
    let
      conf = config.wayland.windowManager.sway.config;
      mod = conf.modifier;
    in
    {
      keybindings = {
        "${mod}+Alt+r" = "exec ${lib.getExe screenrec} --toggle";
      };
      startup = [
        {
          command = "${lib.getExe screenrec} --daemon -h 15 -- --low-power off --output HDMI-A-1 --audio --bitrate \"2 MB\"";
        }
      ];
    };
}
