{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  cfg = config.wayland.windowManager.sway;
in
{
  options.settings.wm.sway = {
    enable = lib.mkEnableOption "swaywm";
  };

  imports = [
    ./colors.nix
    ./keybinds.nix
    ./workspaces.nix
    ./which-key.nix
    ./swaync.nix
    ./swayosd.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf (config.settings.wm.sway.enable) {
      xdg.portal = {
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        enable = true;
        config.common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Screencast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.sway;
        xwayland = true;
        systemd = {
          enable = true; # Enables `sway-session.target` and `graphical-session.target`
          xdgAutostart = true;
        };

        config = {
          bars = [ ];

          startup = [
            { command = lib.getExe pkgs.autotiling-rs; }
            { command = "exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
            {
              command = "exec hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";
            }
          ];

          # Basically window rules
          window.commands = [ ];

          input = {
            "*" = {
              xkb_layout = "no";
              xkb_options = "ctrl:nocaps,shift:both_capslock_cancel,altwin:menu_win,altwin:prtsc_rwin";
              accel_profile = "flat";
            };
          };

          focus.mouseWarping = "container"; # Move mouse to focused window

          window = {
            titlebar = false;
            border = 1;
          };

          # Set wallpapers
          output = {
            "*" = {
              bg = "${
                outputs.packages.${pkgs.system}.wallpaper2.override { colorScheme = config.colorScheme; }
              } fill";
            };
          };

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
      };
    })
  ];
}
