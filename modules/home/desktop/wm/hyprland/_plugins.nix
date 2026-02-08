# This file no longer works, because it requires hyprland to be used as a flake input. It is left here for reference, but is no longer imported
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # None of these plugins work stable and 100% of the time..
  config = lib.mkIf config.settings.wm.hyprland.useFlake {
    wayland.windowManager.hyprland = {
      plugins = [
        inputs.hypr-darkwindow.packages.${pkgs.stdenv.hostPlatform.system}.Hypr-DarkWindow
        inputs.hyprfocus.packages.${pkgs.stdenv.hostPlatform.system}.hyprfocus
      ];
      settings = {
        darkwindow_invert = [ "class:(GeoGebra)" ];

        bind = [ "$mainMod, i, animatefocused" ];

        plugin.hyprfocus = {
          enabled = "yes"; # Does weird animation stuff when opening new windows
          focus_animation = "shrink";
          animate_workspacechange = "yes";
          animate_floating = "yes";
          bezier = [
            "bezIn, 0.5, 0.0, 1.0, 0.5"
            "bezOut, 0.0, 0.5, 0.5, 1.0"
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
            "realsmooth, 0.28, 0.29, 0.69, 1.08"
          ];
          flash = {
            flash_opacity = 0.8;
            in_bezier = "realsmooth";
            in_speed = 0.5;
            out_bezier = "realsmooth";
            out_speed = 3;
          };
          shrink = {
            shrink_percentage = 0.98;
            in_bezier = "bezIn";
            in_speed = 1;
            out_bezier = "bezOut";
            out_speed = 2;
          };
        };
      };
    };
  };
}
