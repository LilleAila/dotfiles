{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  config = lib.mkIf config.hm.settings.wm.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.xdph.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
  };
}
