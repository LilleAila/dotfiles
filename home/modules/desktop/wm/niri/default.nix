{
  config,
  lib,
  pkgs,
  inputs,
  isNixOS,
  ...
}:
{
  options.settings.niri.enable = lib.mkEnableOption "niri";

  # The NixOS module will automatically import this too.
  imports = lib.optionals (!isNixOS) [ inputs.niri.homeModules.niri ];

  config = lib.mkIf config.settings.niri.enable (
    lib.mkMerge [
      # (lib.mkIf (!isNixOS) {
      #   programs.niri = {
      #     enable = true;
      #   };
      # })
      {
        programs.niri = {
          settings = {
            spawn-at-startup = [
              {
                command = [ (lib.getExe pkgs.xwayland-satellite) ];
              }
            ];

            environment = {
              DISPLAY = ":0";
            };

            binds =
              # Actions includes all of the ones listed here:
              # https://github.com/sodiboo/niri-flake/blob/main/memo-binds.nix
              with config.lib.niri.actions; {
                # `Mod` is super in tty and alt as a nested window
                "Mod+w".action = close-window;
                "Mod+Return".action = spawn "kitty";
                "Mod+Space".action = spawn (lib.getExe pkgs.rofi-wayland) "-show" "drun" "-show-icons";

                "Mod+s".action = screenshot;
                # "Mod+Shift+s".action = screenshot-screen;
                "Mod+Ctrl+s".action = screenshot-window;

                "Mod+h".action = focus-column-left;
                "Mod+l".action = focus-column-right;
                "Mod+j".action = focus-window-down;
                "Mod+k".action = focus-window-up;

                "Mod+Ctrl+h".action = move-column-left;
                "Mod+Ctrl+l".action = move-column-right;
                "Mod+Ctrl+j".action = move-window-down;
                "Mod+Ctrl+k".action = move-window-up;

                "Mod+Shift+h".action = consume-or-expel-window-left;
                "Mod+Shift+l".action = consume-or-expel-window-right;
                "Mod+Shift+k".action = consume-window-into-column;
                "Mod+Shift+j".action = expel-window-from-column;

                "Mod+r".action = switch-preset-column-width;
                "Mod+Shift+r".action = switch-preset-window-height;
                "Mod+Ctrl+r".action = reset-window-height;

                "Mod+o".action = fullscreen-window;
                "Mod+Shift+o".action = maximize-column;
                "Mod+Ctrl+o".action = expand-column-to-available-width;

                "Mod+1".action = focus-workspace 1;
                "Mod+2".action = focus-workspace 2;
                "Mod+3".action = focus-workspace 3;
                "Mod+4".action = focus-workspace 4;
                "Mod+5".action = focus-workspace 5;
                "Mod+6".action = focus-workspace 6;
                "Mod+7".action = focus-workspace 7;
                "Mod+8".action = focus-workspace 8;
                "Mod+9".action = focus-workspace 9;
                "Mod+Shift+1".action = move-column-to-workspace 1;
                "Mod+Shift+2".action = move-column-to-workspace 2;
                "Mod+Shift+3".action = move-column-to-workspace 3;
                "Mod+Shift+4".action = move-column-to-workspace 4;
                "Mod+Shift+5".action = move-column-to-workspace 5;
                "Mod+Shift+6".action = move-column-to-workspace 6;
                "Mod+Shift+7".action = move-column-to-workspace 7;
                "Mod+Shift+8".action = move-column-to-workspace 8;
                "Mod+Shift+9".action = move-column-to-workspace 9;

                "Mod+c".action = center-column;
                "Mod+Minus".action = set-column-width "-10%";
                "Mod+Plus".action = set-column-width "+10%";
                "Mod+Shift+Minus".action = set-window-height "-10%";
                "Mod+Shift+Plus".action = set-window-height "+10%";

                "Mod+f".action = toggle-window-floating;
                "Mod+Shift+f".action = switch-focus-between-floating-and-tiling;

                "Mod+Escape" = {
                  action = toggle-keyboard-shortcuts-inhibit;
                  allow-inhibiting = false;
                };
                "Mod+Shift+Ctrl+q".action = quit;
              };

            layout = {
              gaps = 4;
              focus-ring = {
                width = 1;
                active.color = "#${config.colorScheme.palette.base05}";
                inactive.color = "#${config.colorScheme.palette.base01}";
              };
            };

            prefer-no-csd = true;
            screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";

            # For some reason deviates from the options defined in upstream
            outputs = {
              "eDP-1" = {
                mode = {
                  width = 1920;
                  height = 1200;
                  refresh = 60.0;
                };
                scale = 1;
                background-color = "#${config.colorScheme.palette.base00}";
              };
            };

            input = {
              keyboard = {
                xkb = {
                  layout = "no";
                  options = lib.concatStringsSep "," [
                    "ctrl:nocaps"
                    "shift:both_capslock_cancel"
                    "altwin:menu_win"
                    "compose:prsc"
                  ];
                };

                repeat-delay = 200;
                repeat-rate = 60;
              };

              touchpad = {
                tap = false; # idk if neccessary, test
                accel-profile = "flat";
                natural-scroll = true;
              };

              mouse = {
                accel-profile = "flat";
              };

              trackpoint = {
                accel-profile = "flat";
              };

              warp-mouse-to-focus = true;
              focus-follows-mouse.enable = true;
            };
          };
        };
      }
    ]
  );
}
