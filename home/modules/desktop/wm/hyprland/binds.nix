{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "${lib.getExe config.settings.terminal.emulator.package}";
    "$fileManager" = "nemo";
    "$calculator" = "qalculate-gtk";
    "$colorPicker" = "${
      lib.getExe inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    } --render-inactive --autocopy --format=hex";

    "$mainMod" = lib.mkDefault "SUPER";

    bind = [
      # Screenshots

      # Apps
      "$mainMod, return, exec, $terminal"
      # ", XF86Launch1, exec, $terminal"
      "$mainMod, E, exec, emacsclient -c"
      # "$mainMod, D, exec, $fileManager"
      "$mainMod, P, exec, $colorPicker"

      "$mainMod, V, exec, hyprctl reload"
      # TODO sette opp at forskjellige skjerm configs med keubind (jeg gjhør det sikkert senere)
      "$mainMod SHIFT, V, exec, wlr-randr --output HDMI-A-1 --transform 90 --pos -1080,-1100"

      # Special workspaces
      "$mainMod, Q, exec, bash -c 'pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &'"
      "$mainMod SHIFT, Q, movetoworkspace, special:calculator"

      "$mainMod, C, togglespecialworkspace, config"
      "$mainMod SHIFT, C, movetoworkspace, special:config"

      "$mainMod, Z, togglespecialworkspace"
      "$mainMod SHIFT, Z, movetoworkspace, special"

      "$mainMod, X, togglespecialworkspace, secondary"
      "$mainMod SHIFT, X, movetoworkspace, special:secondary"

      "$mainMod SHIFT, P, exec, ${inputs.woomer.packages.${pkgs.system}.default}/bin/woomer"

      # WM commands
      # ", XF86PowerOff, exec, pgrep -x wlogout && pkill -x wlogout || wlogout"
      # ", XF86Launch1, exec, pgrep -x wlogout && pkill -x wlogout || wlogout"
      ", XF86WLAN, exec, rfkill toggle all"
      ", XF86Back, workspace, -1"
      ", XF86Forward, workspace, +1"

      "$mainMod, W, killactive,"
      "$mainMod, O, fullscreen, 0"
      "$mainMod SHIFT, O, fullscreen, 1"
      "$mainMod ALT, O, fakefullscreen"
      "$mainMod, F, togglefloating,"
      # "$mainMod, P, pseudo,"
      "$mainMod, T, togglesplit,"
      # "$mainMod, M, exit," # use wlogout instead

      # Move focus
      "$mainMod, h, movefocus, l"
      "$mainMod, j, movefocus, d"
      "$mainMod, k, movefocus, u"
      "$mainMod, l, movefocus, r"

      # Move windows
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, j, movewindow, d"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, l, movewindow, r"

      "$mainMod CONTROL, 1, movewindow, mon:0"
      "$mainMod CONTROL, 2, movewindow, mon:1"
      "$mainMod CONTROL, 3, movewindow, mon:2"
      "$mainMod CONTROL, 4, movewindow, mon:3"

      "$mainMod ALT SHIFT, h, moveactive, -10 0"
      "$mainMod ALT SHIFT, j, moveactive, 0 -10"
      "$mainMod ALT SHIFT, k, moveactive, 0 10"
      "$mainMod ALT SHIFT, l, moveactive, 10 0"

      # Swap windows
      "$mainMod CONTROL, h, swapwindow, l"
      "$mainMod CONTROL, j, swapwindow, d"
      "$mainMod CONTROL, k, swapwindow, u"
      "$mainMod CONTROL, l, swapwindow, r"

      "$mainMod, n, swapnext"
      "$mainMod SHIFT, n, swapnext, prev"

      # Switch workspace with $mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move window to workspace with $mainMod + SHIFT + [1-10]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Move workspaces between monitors
      "$mainMod ALT, 1, movecurrentworkspacetomonitor, 0"
      "$mainMod ALT, 2, movecurrentworkspacetomonitor, 1"
      "$mainMod ALT, 3, movecurrentworkspacetomonitor, 2"
      "$mainMod ALT, 4, movecurrentworkspacetomonitor, 3"

      # Scroll through workspaces with $mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up  , workspace, e-1"
    ];

    # Move/resize windows with $mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
      "$mainMod ALT, mouse:272, resizewindow"
    ];

    # l -> do stuff even when locked
    # e -> repeats when key is held
    binde = [
      # Resize windows
      "$mainMod ALT, h, resizeactive, -10 0"
      "$mainMod ALT, j, resizeactive, 0 -10"
      "$mainMod ALT, k, resizeactive, 0 10"
      "$mainMod ALT, l, resizeactive, 10 0"
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      "SHIFT, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    bindle =
      let
        setvol = "wpctl set-volume -l 1";
      in
      [
        ", XF86AudioRaiseVolume, exec, ${setvol} @DEFAULT_AUDIO_SINK@ 10%+"
        ", XF86AudioLowerVolume, exec, ${setvol} @DEFAULT_AUDIO_SINK@ 10%-"
        "SHIFT, XF86AudioRaiseVolume, exec, ${setvol} @DEFAULT_AUDIO_SOURCE@ 10%+"
        "SHIFT, XF86AudioLowerVolume, exec, ${setvol} @DEFAULT_AUDIO_SOURCE@ 10%-"

        ", XF86MonBrightnessUp, exec, brightnessctl set 15%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 15%-"
      ];
  };
}
