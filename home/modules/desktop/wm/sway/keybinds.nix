{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkIf config.settings.wm.sway.enable {
  wayland.windowManager.sway.config =
    let
      conf = config.wayland.windowManager.sway.config;
      mod = conf.modifier;
    in
    {
      left = "h";
      down = "j";
      up = "k";
      right = "l";
      terminal = config.settings.terminal.emulator.exec;
      menu = "${lib.getExe pkgs.rofi-wayland} -show drun -show-icons"; # TODO: Actually set up a launcher (ags)
      modifier = "Mod4"; # This is super
      # https://depau.github.io/sway-cheatsheet/
      # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/sway.nix
      # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/lib/options.nix
      keybindings = {
        # === WM-Related ===
        "${mod}+Return" = "exec ${conf.terminal}";
        "${mod}+w" = "kill";
        "${mod}+Space" = "exec ${conf.menu}";

        "${mod}+Shift+r" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        # === Windows ===
        "${mod}+${conf.left}" = "focus left";
        "${mod}+${conf.down}" = "focus down";
        "${mod}+${conf.up}" = "focus up";
        "${mod}+${conf.right}" = "focus right";

        "${mod}+Shift+${conf.left}" = "move left";
        "${mod}+Shift+${conf.down}" = "move down";
        "${mod}+Shift+${conf.up}" = "move up";
        "${mod}+Shift+${conf.right}" = "move right";

        "${mod}+r" = "mode resize";

        # === Layouts ===
        # "${mod}+b" = "splith";
        # "${mod}+v" = "splitv";
        "${mod}+o" = "fullscreen toggle";
        # "${mod}+a" = "focus parent";

        # "${mod}+s" = "layout stacking";
        # "${mod}+t" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+f" = "floating toggle";
        # "${mod}+m" = "focus mode_toggle";

        # === Workspaces ===
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+Shift+z" = "move scratchpad";
        "${mod}+z" = "scratchpad show";

        # === Screenshots ===
        # TODO: set up similar to in hyprland
        "${mod}+s" = "exec grim -g \"$(slurp)\" - | wl-copy";

        # === Apps ===
        "${mod}+b" = "exec firefox -P main";
        "${mod}+Shift+b" = "exec wlr-which-key firefox";
        "${mod}+d" = "exec vesktop";
        "${mod}+p" = "exec wlr-which-key power";

        # === Volume and brightness ===
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%-";
        "Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 10%+";
        "Shift+XF86AudioLowerVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 10%-";

        "XF86MonBrightnessUp" = "exec brightnessctl set 15%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 15%-";
      };

      modes = {
        resize = {
          "${conf.left}" = "resize shrink width 10px";
          "${conf.down}" = "resize shrink height 10px";
          "${conf.up}" = "resize shrink height 10px";
          "${conf.right}" = "resize shrink width 10px";
          "Shift+${conf.left}" = "resize grow width 10px";
          "Shift+${conf.down}" = "resize grow height 10px";
          "Shift+${conf.up}" = "resize grow height 10px";
          "Shift+${conf.right}" = "resize grow width 10px";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };

    };
}
