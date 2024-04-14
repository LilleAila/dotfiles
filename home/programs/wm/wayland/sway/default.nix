{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.wayland.windowManager.sway;
in {
  options.settings.wm.sway = {
    enable = lib.mkEnableOption "swaywm";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.wm.sway.enable) {
      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.swayfx;
        xwayland = true;
        systemd = {
          enable = true; # Enables `sway-session.target` and `graphical-session.target`
          xdgAutostart = true;
        };

        config = let
          conf = cfg.config;
          mod = conf.modifier;
        in {
          left = "h";
          down = "j";
          up = "k";
          right = "l";
          terminal = config.settings.terminal.emulator.exec;
          menu = "${lib.getExe pkgs.rofi-wayland} -show drun -show-icons"; # TODO: Actually set up a launcher (ags)
          modifier = "Mod4"; # This is super
          # https://depau.github.io/sway-cheatsheet/
          # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/sway.nix
          # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/lib/options.nix
          keybindings = {
            # === WM-Related ===
            "${mod}+Return" = "exec ${conf.terminal}";
            "${mod}+w" = "kill";
            "${mod}+Space" = "exec ${conf.menu}";

            "${mod}+Shift+r" = "reload";
            "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            # === Windows ===
            "${mod}+${conf.left}" = "focus left";
            "${mod}+${conf.down}" = "focus down";
            "${mod}+${conf.up}" = "focus up";
            "${mod}+${conf.right}" = "focus right";

            "${mod}+Shift+${conf.left}" = "move left";
            "${mod}+Shift+${conf.down}" = "move down";
            "${mod}+Shift+${conf.up}" = "move up";
            "${mod}+Shift+${conf.right}" = "move right";

            "${mod}+r" = "mode resize";

            # === Layouts ===
            "${mod}+b" = "splith";
            "${mod}+v" = "splitv";
            "${mod}+o" = "fullscreen toggle";
            "${mod}+a" = "focus parent";

            "${mod}+s" = "layout stacking";
            "${mod}+t" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            "${mod}+f" = "floating toggle";
            "${mod}+m" = "focus mode_toggle";

            # === Workspaces ===
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";

            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";

            "${mod}+Shift+z" = "move scratchpad";
            "${mod}+z" = "scratchpad show";
          };

          modes = {
            resize = {
              "${conf.left}" = "resize shrink width 10px";
              "${conf.down}" = "resize shrink height 10px";
              "${conf.up}" = "resize shrink height 10px";
              "${conf.right}" = "resize shrink width 10px";
              "Shift+${conf.left}" = "resize grow width 10px";
              "Shift+${conf.down}" = "resize grow height 10px";
              "Shift+${conf.up}" = "resize grow height 10px";
              "Shift+${conf.right}" = "resize grow width 10px";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };

          colors = let
            c = config.colorScheme.palette;
          in {
            background = "#${c.base00}";
            focused = {
              border = "#${c.base05}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
              childBorder = "#${c.base02}";
            };
            focusedInactive = {
              border = "#${c.base02}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
              childBorder = "#${c.base02}";
            };
            unfocused = {
              border = "#${c.base01}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
              childBorder = "#${c.base02}";
            };
            urgent = {
              border = "#${c.base0A}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
              childBorder = "#${c.base02}";
            };
            placeholder = {
              border = "#${c.base01}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
              childBorder = "#${c.base02}";
            };
          };

          bars = [];

          input = {
            "*" = {
              xkb_layout = "no";
              xkb_options = "ctrl:nocaps";
            };
          };

          window = {
            titlebar = false;
            border = 0;
          };

          # Set wallpapers
          output = {
            # "*" = {bg = "";};
          };

          workspaceAutoBackAndForth = true; # Switch twice to return
          defaultWorkspace = "workspace number 1";
          workspaceOutputAssign = [
            {
              workspace = "number 1";
              output = "eDP-1";
            }
            {
              workspace = "number 2";
              output = "eDP-1";
            }
            {
              workspace = "number 3";
              output = "eDP-1";
            }
            {
              workspace = "number 4";
              output = "eDP-1";
            }
            {
              workspace = "number 5";
              output = "eDP-1";
            }
            {
              workspace = "number 6";
              output = "HDMI-A-1";
            }
            {
              workspace = "number 7";
              output = "HDMI-A-1";
            }
            {
              workspace = "number 8";
              output = "HDMI-A-1";
            }
            {
              workspace = "number 9";
              output = "HDMI-A-1";
            }
            {
              workspace = "number 10";
              output = "HDMI-A-1";
            }
          ];

          gaps = {
            inner = 0;
            outer = 0;
            horizontal = 0;
            vertical = 0;
            top = 0;
            left = 0;
            bottom = 0;
            right = 0;
          };
        };
        # Monitor config, set graphically and imperativaly with nwg-displays
        extraConfig = ''
          include $HOME/.config/sway/outputs

          blur enable
          corner_radius 0
          shadows disable
          default_dim_inactive 0.2
        '';
      };
    })
  ];
}
