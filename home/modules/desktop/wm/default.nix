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
    ./niri
    ./wayland # shared
  ];
}
