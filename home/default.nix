{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home = {
    username = "olai";
    homeDirectory = "/home/olai";
    stateVersion = "23.11"; # Changed from stable 23.05
  };

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./programs/shell

    ./programs/browser.nix
    ./programs/discord
    ./programs/emacs
    ./programs/zathura.nix
    ./programs/files.nix
    ./programs/other.nix
    ./programs/fonts.nix
    ./programs/fcitx5
    ./programs/webapps

    # ./programs/wallpaper/wallpaper.nix
    ./programs/wm/wayland
    ./programs/wm/ags
  ];

  home.packages = with pkgs; [
    gcc
    cmake

    fd

    nodejs_20
    python311
    dconf

    nurl
    sops
  ];
}
