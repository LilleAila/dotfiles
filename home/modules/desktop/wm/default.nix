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
    ./wayland # shared
  ];
}
