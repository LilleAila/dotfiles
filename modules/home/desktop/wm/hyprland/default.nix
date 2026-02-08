{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings.wm.hyprland = {
        enable = lib.mkEnableOption "hyprland";
      };

      config = lib.mkIf config.settings.wm.hyprland.enable {
        settings.persist.home.cache = [ ".cache/hyprland" ];

        # Random dependencies and stuff
        home.packages = with pkgs; [
          libnotify
          pamixer
          pavucontrol
          playerctl
          brightnessctl
          qalculate-gtk
          wlr-randr
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          # package = lib.mkDefault pkgs.hyprland;
          systemd.enable = true;
          xwayland.enable = true;
        };

        settings.wm.hyprland.screenshots.enable = lib.mkDefault true;
      };
    };
}
