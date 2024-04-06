{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  options.settings.wm.hyprlock.enable = lib.mkEnableOption "hyprlock";

  config = lib.mkIf (config.settings.wm.hyprlock.enable) {
    programs.hyprlock = let
      primaryMonitor = (builtins.elemAt config.settings.monitors 0).name;
    in {
      enable = true;
      general = {
        disable_loading_bar = true;
        grace = 1;
        hide_cursor = true;
        no_fade_in = false;
        no_fade_out = false;
      };

      backgrounds = map (m: {
        # monitor = "${primaryMonitor}";
        monitor = "${m.name}";
        path = "screenshot";
        # path = "${m.wallpaper}"; # TODO: This doesn't work rn because only PNG is supported..
        color = "rgb(${config.colorScheme.palette.base01})";

        # Blur
        blur_size = 8;
        blur_passes = 2;
        noise = 0.0117;
        contrast = 0.8917;
        brightness = 0.8172;
        vibrancy = 0.1686;
        vibrancy_darkness = 0.05;
      }) (config.settings.monitors);

      input-fields = [
        {
          # monitor = "eDP-1";
          monitor = "${primaryMonitor}";
          size = {
            width = 500;
            height = 50;
          };
          outline_thickness = 4;
          dots_size = 0.5;
          dots_spacing = 0.15;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(${config.colorScheme.palette.base01})";
          inner_color = "rgb(${config.colorScheme.palette.base02})";
          font_color = "rgb(${config.colorScheme.palette.base06})";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Input password...</i>";
          # hide_input = true;
          hide_input = false;
          rounding = -1;
          check_color = "rgb(${config.colorScheme.palette.base0B})";
          fail_color = "rgb(${config.colorScheme.palette.base08})";
          fail_text = "<i>$FAIL</i>";
          fail_transition = 300;
          position = {
            x = 0;
            y = -20;
          };
          halign = "center";
          valign = "center";
          capslock_color = "rgb(${config.colorScheme.palette.base0E})";
          numlock_color = "-1";
          bothlock_color = "-1";
          invert_numlock = false;
        }
      ];

      labels = [
        {
          monitor = "${primaryMonitor}";
          text = "Hi there, $USER";
          color = "rgb(${config.colorScheme.palette.base06})";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font";
          position = {
            x = 0;
            y = 80;
          };
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
