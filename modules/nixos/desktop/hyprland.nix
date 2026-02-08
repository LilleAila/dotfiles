{ lib, ... }:
{
  flake.modules.nixos.hyprland =
    {
      pkgs,
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
    };
}
