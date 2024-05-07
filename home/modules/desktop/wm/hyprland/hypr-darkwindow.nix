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
    ];
    settings = {
      darkwindow_invert = "class:(GeoGebra)";
    };
  };
}
