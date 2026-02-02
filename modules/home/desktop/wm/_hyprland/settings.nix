{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # Monitor fallback
      ", preferred, auto, 1"
    ];

    xwayland = {
      use_nearest_neighbor = false; # Blurry rather than pixelated
      force_zero_scaling = true;
    };

    input = {
      kb_layout = "no";
      follow_mouse = 1;
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        tap-to-click = lib.mkDefault false;
        clickfinger_behavior = true; # one, two and three finger click
      };
      sensitivity = 0.0;
      accel_profile = "flat";
      kb_options = lib.mkDefault "ctrl:nocaps";
    };

    # "device:synps/2-synaptics-touchpad"

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 4;
      workspace_swipe_distance = 400;
      workspace_swipe_min_speed_to_force = 25;
      workspace_swipe_create_new = false;
      # workspace_swipe_numbered = true;
    };

    general = {
      gaps_in = 0;
      gaps_out = 0;
      gaps_workspaces = 0;
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
        enabled = false; # Disabled blur
        brightness = 1.0;
        contrast = 1.0;
        noise = 2.0e-2;
        passes = 3;
        size = 10;
        vibrancy = 0.1696;
        # popups = true;
        # ignore_opacity = true; # Probably very heavy
        # special = true; # blur special wses
      };
      drop_shadow = false;
      dim_inactive = false;
      dim_strength = 0.1;
    };

    animations = {
      enabled = "true";
      # Good place to find beziers: https://easings.net/
      bezier = [
        "easeOutQuart, 0.25, 1, 0.5, 1"
        "easeOutQuad, 0.5, 1, 0.89, 1"
        "easeInOutBack, 0.68, -0.6, 0.32, 1.6"
        "linear, 0, 0, 1, 1"
      ];

      animation = [
        "windows, 1, 4, easeOutQuart"
        "windowsOut, 1, 4, easeOutQuart, popin 80%"
        # "windows, 0"
        "border, 0"
        "borderangle, 0"
        "fade, 1, 4, default"
        "workspaces, 1, 2, easeOutQuad, slidevert"
        # "workspaces, 0"
        "specialWorkspace, 1, 4, easeInOutBack, slide"
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
      focus_on_activate = true;
      # Fix some windows opening on workspace 1
      initial_workspace_tracking = false;
    };

    windowrulev2 = [
      "idleinhibit focus, fullscreen:1"

      # "nomaximizerequest, class:.*"

      # Put apps in special workspace
      "float,class:(qalculate-gtk)"
      "workspace special:calculator,class:(qalculate-gtk)"

      "float,class:(nm-*)"
      "float,class:(.blueman-*)"
      "float,class:(pavucontrol)"
      "float,class:(nwg-displays)"
      "workspace special:config,class:(nm-*)"
      "workspace special:config,class:(.blueman-*)"
      "workspace special:config,class:(pavucontrol)"
      "workspace special:config,class:(nwg-displays)"

      "float,class:(Qsynth)"

      "rounding 12, floating:1"
      # "noborder, floating:0" # not needed because border size 0

      # "opacity 0.9, class:(vesktop)"
      # "opacity 0.9, class:(firefox)"
      "opacity 0.9, class:(chrome-monkeytype.com__-Default)"
      # "opacity 0.875, class:(chrome-cstimer.net__-Default)"

      "idleinhibit focus, class:(chrome-cstimer.net__-Default)"
    ];

    layerrule = [
      # If i was using blur:
      # "blur, bar*"
      # "ignorealpha 0.2, bar*"
      # "ignorezero, bar*" # ignorealpha but only for =0 values

      # "noanim, bar*"
      # "noanim, osd*"
      # "noanim, powermenu*"
      # "animation slide left, powermenu*"

      # "blur, notifications*"
      # "ignorezero, notifications*"
      # "noanim, notifications*"
      #
      # "blur, applauncher"
      # "ignorezero, applauncher"
      # "noanim, applauncher"
    ];
  };
}
