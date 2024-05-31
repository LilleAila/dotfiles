{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.settings.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = lib.mkStrOption "eDP-1";
        wallpaper = lib.mkOption' types.path null;
        geometry = lib.mkOption' (types.nullOr types.str) null;
        position = lib.mkOption' (types.nullOr types.str) null;
        scale = lib.mkOption' types.int 1;
        enable = lib.mkDisableOption "this monitor";
        rotation = lib.mkOption' types.int 0;
      };
    });
    default = [];
    description = ''
      Monitor configuration for hyprland
    '';
  };

  options.settings.wm.hyprland.monitors.enable = lib.mkEnableOption "hyprland monitors";

  config = lib.mkIf config.settings.wm.hyprland.enable (lib.mkMerge [
    (lib.mkIf (!config.settings.wm.hyprland.monitors.enable) {
      # Configured through nwg-displays
      home.packages = [pkgs.nwg-displays];
      wayland.windowManager.hyprland.settings.source = [
        "~/.config/hypr/monitors.conf"
        "~/.config/hypr/workspaces.conf"
      ];
    })
    (lib.mkIf config.settings.wm.hyprland.monitors.enable {
      wayland.windowManager.hyprland.settings.monitor =
        map
        (
          m: "${m.name},${
            if m.enable
            then "${m.geometry},${m.position},${toString m.scale}${
              if (m.rotation != 0)
              then ",transform,${toString m.rotation}"
              else ""
            }"
            else "disable"
          }"
        )
        (config.settings.monitors);
    })
  ]);
}
