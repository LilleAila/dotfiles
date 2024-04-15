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
        # width = mkOption {
        #   type = types.int;
        #   example = 1920;
        # };
        # height = mkOption {
        #   type = types.int;
        #   default = 1080;
        # };
        # refreshRate = mkOption {
        #   type = types.int;
        #   default = 60;
        # };
        # x = mkOption {
        #   type = types.int;
        #   default = 0;
        # };
        # y = mkOption {
        #   type = types.int;
        #   default = 0;
        # };
        # scale = mkOption {
        #   type = types.int;
        #   default = 1;
        # };
        # enable = mkOption {
        #   type = types.bool;
        #   default = true;
        # };
        wallpaper = mkOption {
          type = types.path;
          default = null;
        };
        # primary = mkOption {
        #   type = types.bool;
        #   default = false;
        # };
        # rotation = mkOption {
        #   type = types.int;
        #   default = 0;
        # };
      };
    });
    default = [];
    description = ''
      Monitor configuration for hyprland
    '';
  };

  config = {
    home.packages = [pkgs.nwg-displays];
    # Switched to using nwg-displays instead (:o no declarative?????)
    # wayland.windowManager.hyprland.settings.monitor =
    #   map
    #   (
    #     m: let
    #       resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
    #       position = "${toString m.x}x${toString m.y}";
    #       scale = "${toString m.scale}";
    #     in "${m.name},${
    #       if m.enable
    #       then "${resolution},${position},${scale}${
    #         if (m.rotation != 0)
    #         then ",transform,${toString m.rotation}"
    #         else ""
    #       }"
    #       else "disable"
    #     }"
    #   )
    #   (config.settings.monitors);
  };
}
