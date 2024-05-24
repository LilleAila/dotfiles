{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  keys,
  ...
}: {
  imports = [../../home];

  settings = {
    monitors = [
      {
        name = "eDP-1";
        wallpaper = outputs.packages.${pkgs.system}.wallpaper.override {
          scheme = config.colorScheme;
        };
        geometry = "1920x1200@60";
        position = "0x0";
      }
    ];
    desktop.enable = true;
    #nix.unfree = [
    #  "1password"
    #  "1password-gui"
    #  "geogebra"
    #];
    wm.hyprland.monitors.enable = true;
    wm.hyprland.useFlake = true;
  };
  home.shellAliases = {
    bt = "bluetooth";
  };
  home.packages = with pkgs; [
  ];
}
