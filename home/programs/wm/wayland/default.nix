{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./monitors.nix
    ./hyprland
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
