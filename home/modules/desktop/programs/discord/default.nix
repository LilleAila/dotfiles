{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.settings.discord = {
    vesktop.enable = lib.mkEnableOption "vesktop";
    dissent.enable = lib.mkEnableOption "dissent";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.discord.dissent.enable) {
      home.packages = with pkgs; [dissent];
    })
    (lib.mkIf (config.settings.discord.vesktop.enable) {
      home.packages = with pkgs; [
        vesktop
      ];

      home.file.".config/vesktop/settings.json" = {
        source =
          pkgs.writeText "settings.json"
          /*
          json
          */
          ''
            {
                "splashColor": "#${config.colorScheme.palette.base05}",
                "splashBackground": "#${config.colorScheme.palette.base01}",
                "customTitleBar": false,
                "staticTitle": true,
                "splashTheming": true,
                "tray": false,
                "minimizeToTray": false,
                "disableMinSize": true,
                "appBadge": false,
                "checkUpdates": false,
                "arRPC": true
            }
          '';
      };

      home.file.".config/vesktop/settings/settings.json".source = ./settings.json;

      # Auto-generated color scheme, inspired by https://github.com/deathbeam/base16-discord
      # Slightly modified by changing theme variables in devtools (Ctrl + Shift + i)
      home.file.".config/vesktop/themes/base16.theme.css".source = pkgs.writeText "base16.theme.css" (import ./theme.nix {inherit config;});
    })
    (lib.mkIf (config.settings.wm.hyprland.enable) {
      wayland.windowManager.hyprland.settings = {
        "$discord" = "vesktop";
        bind = [
          # TODO: Make this a general script where "vesktop" is replaced by an argument
          "$mainMod, D, exec, ${pkgs.writeShellScriptBin "toggle_discord"
            /*
            bash
            */
            ''
              #!/usr/bin/env bash

              if [[ $(pgrep -f vesktop | wc -l) -ne 0 ]]; then
              	hyprctl dispatch togglespecialworkspace discord
              else
              	vesktop --enable-wayland-ime &
              fi
            ''}/bin/toggle_discord"
        ];
        windowrulev2 = [
          "float,class:($discord)"
          "workspace special:discord,class:($discord)"
        ];
      };
    })
  ];
}
