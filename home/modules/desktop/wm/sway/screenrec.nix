{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.wl-screenrec-daemon.homeManagerModules.wl-screenrec-daemon ];

  config = lib.mkIf config.settings.wm.sway.enable {
    services.wl-screenrec-daemon = {
      enable = false; # FIXME: Temporarily disabled due to the same thing as with the other wf-recorder-dependent programs
      args = [ "--history 20" ];
      wl-screenrec-args = [
        "--low-power off"
        "--output HDMI-A-1"
        "--audio"
        "--audio-device alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game.monitor"
        "--bitrate \"1 MB\""
      ];
    };

    wayland.windowManager.sway.config =
      let
        conf = config.wayland.windowManager.sway.config;
        mod = conf.modifier;
      in
      {
        keybindings = {
          "${mod}+Alt+r" = "exec wl-screenrec-daemon --toggle";
        };
        # startup = [
        #   {
        #     command = "${lib.getExe screenrec} --daemon -h 20 -- --low-power off --output HDMI-A-1 --audio --audio-device alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game.monitor --bitrate \"2 MB\"";
        #   }
        # ];
      };
  };
}
