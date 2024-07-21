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
    };
  };
}
