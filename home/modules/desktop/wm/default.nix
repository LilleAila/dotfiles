{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hyprland
    ./sway
    ./wayfire
    # ./niri
    ./wayland # shared
  ];
}
