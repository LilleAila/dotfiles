{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  startupScript =
    pkgs.pkgs.writeShellScriptBin "start"
    /*
    bash
    */
    ''
      ${pkgs.mako}/bin/mako &
    '';
in {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # Monitor fallback
      ", preferred, auto, 1"
    ];
    # TODO: completely replace the startup script with systemd services (only mako left)
    exec-once = [
      "${startupScript}/bin/start"
    ];
    env = [
      "XCURSOR_SIZE,24"
      "GRIMBLAST_EDITOR,\"swappy -f\""
    ];

    input = {
      kb_layout = "no";
      follow_mouse = 1;
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        tap-to-click = false;
        clickfinger_behavior = true; # one, two and three finger click
      };
      sensitivity = 0.0;
      accel_profile = "flat";
      kb_options = [
        "ctrl:nocaps"
      ];
    };

    # "device:synps/2-synaptics-touchpad"

    gestures = {
      workspace_swipe = false;
    };

    general = {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 0;
      "col.active_border" = "rgb(${config.colorScheme.palette.base04}) rgb(${config.colorScheme.palette.base05}) 45deg";
      "col.inactive_border" = "rgb(${config.colorScheme.palette.base00})";
      layout = "dwindle";
      allow_tearing = "false";
      cursor_inactive_timeout = 1;
    };

    decoration = {
      rounding = 0;
      blur = {
        # enabled = false;
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.02;
        passes = 3;
        size = 10;
        vibrancy = 0.1696;
      };
      drop_shadow = false;
      dim_inactive = true;
      dim_strength = 0.2;
    };

    animations = {
      enabled = "true";
      # Good place to find beziers: https://easings.net/
      bezier = [
        "easeOutQuart, 0.25, 1, 0.5, 1"
        "easeOutQuad, 0.5, 1, 0.89, 1"
        "easeInOutBack, 0.68, -0.6, 0.32, 1.6"
      ];

      animation = [
        "windows, 1, 4, easeOutQuart"
        "windowsOut, 1, 4, easeOutQuart, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 4, default"
        "workspaces, 1, 2, easeOutQuad"
        "specialWorkspace, 1, 4, easeInOutBack, slidevert"
      ];
    };

    dwindle = {
      pseudotile = "true";
      preserve_split = "true";
    };

    master = {
      new_is_master = "true";
    };

    misc = {
      force_default_wallpaper = 0;
      # disable_hyprland_logo = true
      vfr = true;
    };

    windowrulev2 = [
      # "nomaximizerequest, class:.*"

      # Put apps in special workspace
      "float,class:(qalculate-gtk)"
      "workspace special:calculator,class:(qalculate-gtk)"

      "float,class:(nm-*)"
      "float,class:(.blueman-*)"
      "float,class:(pavucontrol)"
      "workspace special:config,class:(nm-*)"
      "workspace special:config,class:(.blueman-*)"
      "workspace special:config,class:(pavucontrol)"

      "rounding 12, floating:1"
      "noborder, floating:0"
    ];

    layerrule = [
      "blur, bar*"
      "ignorealpha 0.2, bar*"
      "blur, powermenu"
      "ignorealpha 0.2, powermenu"
      "blur, corner*"
      "ignorealpha 0.2, corner*"
    ];
  };
}
