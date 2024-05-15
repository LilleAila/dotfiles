{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # None of these plugins work stable and 100% of the time..
  config = lib.mkIf config.settings.wm.hyprland.useFlake {
    wayland.windowManager.hyprland = {
      plugins = [
        inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
        # inputs.hyprspace.packages.${pkgs.system}.Hyprspace
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
      ];
      settings = {
        darkwindow_invert = [
          "class:(GeoGebra)"
        ];

        bind = [
          # "$mainMod, i, hyprexpo:expo, toggle"
          # "$mainMod, i, overview:toggle, all"
          "$mainMod, i, animatefocused"
        ];

        plugin.hyprfocus = {
          enabled = "yes";
          focus_animation = "shrink";
          animate_workspacechange = "yes";
          animate_floating = "yes";
          bezier = [
            "bezIn, 0.5, 0.0, 1.0, 0.5"
            "bezOut, 0.0, 0.5, 0.5, 1.0"
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
            "realsmooth, 0.28, 0.29, 0.69, 1.08"
          ];
          flash = {
            flash_opacity = 0.8;
            in_bezier = "realsmooth";
            in_speed = 0.5;
            out_bezier = "realsmooth";
            out_speed = 3;
          };
          shrink = {
            shrink_percentage = 0.98;
            in_bezier = "bezIn";
            in_speed = 1;
            out_bezier = "bezOut";
            out_speed = 2;
          };
        };

        # plugin.overview = let
        #   c = config.colorScheme.palette;
        # in {
        #   panelColor = "rgb(${c.base00})";
        #   panelBorderColor = "rgb(${c.base01})";
        #   workspaceActiveBackground = "rgb(${c.base01})";
        #   workspaceActiveBorder = "rgb(${c.base02})";
        #   workspaceInactiveBackground = "rgb(${c.base00})";
        #   workspaceInactiveBorder = "rgb(${c.base01})";
        #   dragAlpha = 0.8;
        #
        #   panelHeight = 140;
        #   panelBorderWidth = 4;
        #   onBottom = false;
        #   workspaceMargin = 10;
        #   reservedArea = lib.mkDefault 0; # Override for macbook?
        #   centerAligned = true;
        #   hideBackgroundLayers = false;
        #   hideTopLayers = true;
        #   hideOverlayLayers = true;
        #   hideRealLayers = true;
        #   drawActiveWorkspace = true;
        #   overrideGaps = false;
        #   # gapsIn = 4;
        #   # gapsOut = 4;
        #   affectStrut = false;
        #
        #   overrideAnimSpeed = 0.4;
        #
        #   exitOnClick = true;
        #   showNewWorkspace = true;
        #   showEmptyWorkspace = true;
        # };

        # plugin.hyprexpo = {
        #   columns = 3;
        #   gap_size = 5;
        #   bg_col = "rgb(${config.colorScheme.palette.base00})";
        #   workspace_method = "first 1";
        #   enable_gesture = true;
        #   gesture_distance = 300;
        #   gesture_positive = true;
        # };
      };
    };
  };
}
