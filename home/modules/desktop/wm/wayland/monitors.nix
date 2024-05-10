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
        name = mkOption {
          type = types.str;
          example = "eDP-1";
        };
        wallpaper = mkOption {
          type = types.path;
          default = null;
        };
        geometry = mkOption {
          type = types.nullOr types.str;
        };
        position = mkOption {
          type = types.nullOr types.str;
        };
        scale = mkOption {
          type = types.int;
          default = 1;
        };
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        rotation = mkOption {
          type = types.int;
          default = 0;
        };
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
