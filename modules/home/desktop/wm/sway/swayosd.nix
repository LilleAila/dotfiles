{ lib, ... }:
{
  flake.modules.homeManager.swayosd =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    lib.mkIf config.settings.wm.sway.enable {
      services.swayosd = {
        enable = true;
        display = (builtins.head config.settings.monitors).name;
        topMargin = 5.0e-2;
        stylePath = pkgs.stdenv.mkDerivation {
          name = "style.css";
          nativeBuildInputs = [ pkgs.sass ];
          src =
            let
              c = config.colorScheme.palette;
            in
            pkgs.writeText "style.scss"
              #scss
              ''
                window#osd {
                  padding: 20px;
                  border-radius: 0;
                  background-color: #${c.base00};
                  border: 1px solid #${c.base05};

                  #container {
                    margin: 16px;
                  }

                  image,
                  label {
                    color: #${c.base06};
                  }

                  progressbar:disabled,
                  image:disabled {
                    opacity: 0.5;
                  }

                  progressbar {
                    min-height: 6px;
                    border-radius: 999px;
                    background-color: #${c.base03};
                    border: none;
                  }
                  trough {
                    min-height: inherit;
                    border-radius: inherit;
                    border: none;
                    background-color: #${c.base03};
                  }
                  progress {
                    min-height: inherit;
                    border-radius: inherit;
                    border: none;
                    background-color: #${c.base06};
                  }
                }
              '';
          unpackPhase = "true";
          buildPhase = ''
            sass $src $out
          '';
        };
      };

      wayland.windowManager.sway.config.keybindings = {
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "Shift+XF86AudioRaiseVolume" = "exec swayosd-client --input-volume raise";
        "Shift+XF86AudioLowerVolume" = "exec swayosd-client --input-volume lower";
        "Shift+XF86AudioMute" = "exec swayosd-client --input-volume mute-toggle";
        "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

        "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";

        # "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+";
        # "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%-";
        # "Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 10%+";
        # "Shift+XF86AudioLowerVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 10%-";
        #
        # "XF86MonBrightnessUp" = "exec brightnessctl set 15%+";
        # "XF86MonBrightnessDown" = "exec brightnessctl set 15%-";
      };
    };
}
