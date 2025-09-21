{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.settings.aerospace = {
    enable = lib.mkEnableOption "aerospace";
    float = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf config.settings.aerospace.enable {
    settings.aerospace.float = [ ];

    launchd.user.agents.aerospace.serviceConfig.Nice = -20;

    services.aerospace = {
      enable = true;
      settings = {
        automatically-unhide-macos-hidden-apps = true;
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        on-window-detected =
          (map (app-id: {
            "if" = {
              inherit app-id;
            };
            run = "layout floating";
          }) config.settings.aerospace.float)
          # below code does not seem to work... todo
          ++ [
            {
              "if" = {
                app-id = "com.hnc.discord";
              };
              run = "move-node-to-workspace z";
            }
          ];

        # Might interfere with apps etc.
        mode.main.binding = {
          # Could be made more generic to support other apps
          cmd-enter = "exec-and-forget osascript ${pkgs.writeText "open-ghostty.applescript" ''
            tell application "Ghostty"
              if it is running then
                activate
                tell application "System Events" to keystroke "n" using {command down}
              else
                activate
              end if
            end tell
          ''}";

          alt-r = "reload-config";
          alt-o = "fullscreen";
          alt-f = "layout floating tiling";
          alt-shift-t = "layout tiles";

          cmd-h = "focus left";
          cmd-j = "focus down";
          cmd-k = "focus up";
          cmd-l = "focus right";
          cmd-ctrl-h = "move left";
          cmd-ctrl-j = "move down";
          cmd-ctrl-k = "move up";
          cmd-ctrl-l = "move right";
          cmd-shift-h = "join-with left";
          cmd-shift-j = "join-with down";
          cmd-shift-k = "join-with up";
          cmd-shift-l = "join-with right";

          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          cmd-alt-1 = "workspace 1";
          cmd-alt-2 = "workspace 2";
          cmd-alt-3 = "workspace 3";
          cmd-alt-4 = "workspace 4";
          cmd-alt-5 = "workspace 5";
          cmd-alt-6 = "workspace 6";
          cmd-alt-7 = "workspace 7";
          cmd-alt-8 = "workspace 8";
          cmd-alt-9 = "workspace 9";
          cmd-alt-0 = "workspace 10";
          cmd-alt-z = "workspace z";
          cmd-alt-o = "workspace o";
          cmd-alt-shift-1 = "move-node-to-workspace 1";
          cmd-alt-shift-2 = "move-node-to-workspace 2";
          cmd-alt-shift-3 = "move-node-to-workspace 3";
          cmd-alt-shift-4 = "move-node-to-workspace 4";
          cmd-alt-shift-5 = "move-node-to-workspace 5";
          cmd-alt-shift-6 = "move-node-to-workspace 6";
          cmd-alt-shift-7 = "move-node-to-workspace 7";
          cmd-alt-shift-8 = "move-node-to-workspace 8";
          cmd-alt-shift-9 = "move-node-to-workspace 9";
          cmd-alt-shift-0 = "move-node-to-workspace 10";
          cmd-alt-shift-z = "move-node-to-workspace z";
          cmd-alt-shift-o = "move-node-to-workspace o";
        };
      };
    };
  };
}
