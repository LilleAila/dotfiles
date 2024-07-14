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
  ];

  config = lib.mkMerge [
    (lib.mkIf (config.settings.wm.sway.enable) {
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

          startup = [ { command = lib.getExe pkgs.autotiling-rs; } ];

          input = {
            "*" = {
              xkb_layout = "no";
              xkb_options = "ctrl:nocaps";
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
