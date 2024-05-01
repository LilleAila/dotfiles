{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./.
  ];

  settings = {
    monitors = [
      {
        name = "eDP-1";
        wallpaper = ./wallpapers/wall3.jpg;
      }
    ];
    desktop.enable = true;
  };
  wayland.windowManager.hyprland.settings.input.kb_options = lib.mkForce "ctrl:nocaps,altwin:swap_lalt_lwin";
  home.packages = with pkgs; [
    _1password-gui-beta
  ];
}
