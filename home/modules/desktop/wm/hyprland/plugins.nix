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
        # inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
        inputs.hyprspace.packages.${pkgs.system}.Hyprspace
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
      ];
      settings = {
        # darkwindow_invert = "class:(GeoGebra)";
        bind = [
          # "$mainMod, i, hyprexpo:expo, toggle"
          "$mainMod, i, overview:toggle, all"
        ];

        plugin.overview = let
          c = config.colorScheme.palette;
        in {
          panelColor = "rgb(${c.base00})";
          panelBorderColor = "rgb(${c.base01})";
          workspaceActiveBackground = "rgb(${c.base01})";
          workspaceActiveBorder = "rgb(${c.base02})";
          workspaceInactiveBackground = "rgb(${c.base00})";
          workspaceInactiveBorder = "rgb(${c.base01})";
          dragAlpha = 0.8;

          panelHeight = 140;
          panelBorderWidth = 4;
          onBottom = false;
          workspaceMargin = 10;
          reservedArea = lib.mkDefault 0; # Override for macbook?
          centerAligned = true;
          hideBackgroundLayers = false;
          hideTopLayers = true;
          hideOverlayLayers = true;
          hideRealLayers = true;
          drawActiveWorkspace = true;
          overrideGaps = false;
          # gapsIn = 4;
          # gapsOut = 4;
          affectStrut = false;

          overrideAnimSpeed = 0.4;

          exitOnClick = true;
          showNewWorkspace = true;
          showEmptyWorkspace = true;
        };

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
