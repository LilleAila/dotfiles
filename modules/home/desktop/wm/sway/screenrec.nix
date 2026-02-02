{ lib, ... }:
{
  flake.modules.homeManager.screenrec =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [ inputs.wl-screenrec-daemon.homeManagerModules.wl-screenrec-daemon ];

      config = lib.mkIf config.settings.wm.sway.enable {
        # Mismatched hash?? idk FIXME
        # home.packages = [ inputs.wl-screenrec-daemon.packages.${pkgs.system}.wl-screenrec-daemon ];

        services.wl-screenrec-daemon = {
          enable = false;
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
    };
}
