{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./monitors.nix
    # ./hyprlock.nix
    ./swaylock.nix
    ./hypridle.nix
    ./swayidle.nix
    ./hyprpaper.nix
    ./themes.nix
    ./mako.nix
    ./avizo.nix
    ./wlogout.nix
    ./waybar
  ];
}
