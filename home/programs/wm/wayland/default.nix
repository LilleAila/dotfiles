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
    ./monitors.nix
    ./hyprlock.nix
    ./swaylock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./themes.nix
    ./mako.nix
    ./avizo.nix
    ./wlogout.nix
  ];
}
