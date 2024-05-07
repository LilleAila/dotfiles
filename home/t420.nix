{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [./.];

  settings = {
    monitors = [
      {
        name = "LVDS-1";
        wallpaper = ./wallpapers/wall13.jpg;
      }
    ];
    desktop.enable = true;
  };
  services.blueman-applet.enable = false;

  wayland.windowManager.hyprland.settings.input.kb_options = lib.mkForce "ctrl:nocaps,altwin:swap_lalt_lwin,altwin:menu_win";
  # wayland.windowManager.hyprland.settings."$mainMod" = lib.mkForce "ALT_L";
}
