{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
    ./sway
    ./wayfire
    ./wayland # shared
  ];
}
