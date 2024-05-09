{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      # inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
      # inputs.hyprspace.packages.${pkgs.system}.Hyprspace
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];
    settings = {
      # darkwindow_invert = "class:(GeoGebra)";
      bind = [
        "$mainMod, i, hyprexpo:expo, toggle"
      ];

      plugin.hyprexpo = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgb(${config.colorScheme.palette.base00})";
        workspace_method = "first 1";
        enable_gesture = true;
        gesture_distance = 300;
        gesture_positive = false;
      };
    };
  };
}
