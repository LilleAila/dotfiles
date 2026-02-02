{ lib, ... }:
{
  flake.modules.homeManager.hyprland-autostart =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      config = lib.mkIf config.settings.wm.hyprland.enable {
        wayland.windowManager.hyprland.settings = {
          exec-once = [
            "[workspace special:discord silent] vesktop"
            "[workspace 2 silent] firefox -P main"
            "[workspace 1 silent] $terminal"
            "[workspace 1 silent] $terminal"
          ];
        };
      };
    };
}
