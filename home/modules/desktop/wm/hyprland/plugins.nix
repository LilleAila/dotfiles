{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
      # inputs.hyprspace.packages.${pkgs.system}.Hyprspace
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];
    settings = {
      darkwindow_invert = "class:(GeoGebra)";
      bind = [
        # "$mainMod, i, overview:toggle, all"
        # "$mainMod, i, hyprexpo:expo, toggle"
        # "$mainMod, i, animatefocused"
      ];

      # plugin.hyprfocus = {
      #   enabled = "yes";
      #   keyboard_focus_animation = "shrink";
      #   mouse_focus_animation = "flash";
      # };
    };
  };
}
