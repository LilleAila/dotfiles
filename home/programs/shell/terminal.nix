{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.terminal = {
    emulator.enable = lib.mkEnableOption "terminal emulator";
    emulator.name = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
    };
    emulator.exec = lib.mkOption {
      # internal option, do not set in config
      type = lib.types.str;
    };
    emulator.package = lib.mkOption {
      # lib.getExe gets used a lot. maybe make it its own option?
      type = lib.types.package;
    };
  };

  config = lib.mkIf (config.settings.terminal.emulator.enable) (lib.mkMerge [
    (lib.mkIf (config.settings.terminal.emulator.name == "kitty") {
      home.packages = [pkgs.nerdfonts];
      settings.terminal.emulator.package = config.programs.kitty.package;
      settings.terminal.emulator.exec = "${lib.getExe config.settings.terminal.emulator.package} -e";
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        font = {
          name = "JetBrains Mono Nerd Font";
          size = 10;
          package = pkgs.nerdfonts;
        };
        shellIntegration.enableZshIntegration = true;
        shellIntegration.enableFishIntegration = true;
        settings = with config.colorScheme.palette; {
          scrollback_lines = 1000;
          placement_strategy = "center";
          allow_remote_control = "yes";
          enable_audio_bell = "no";
          copy_on_select = "clipboard";
          background_opacity = "0.7";

          foreground = "#${base06}";
          background = "#${base00}";
          selection_foreground = "#${base05}";
          selection_background = "#${base02}";
          cursor = "#${base06}";
          cursor_text_color = "#${base00}";
          # Black
          color0 = "#${base00}";
          color8 = "#${base04}";
          # Red
          color1 = "#${base08}";
          color9 = "#${base08}";
          # Green
          color2 = "#${base0B}";
          color10 = "#${base0B}";
          # Yellow
          color3 = "#${base0A}";
          color11 = "#${base0A}";
          # Blue
          color4 = "#${base0D}";
          color12 = "#${base0D}";
          # Magenta
          color5 = "#${base0E}";
          color13 = "#${base0E}";
          # Cyan
          color6 = "#${base0C}";
          color14 = "#${base0C}";
          # White
          color7 = "#${base06}";
          color15 = "#${base06}";
        };
      };
    })
    (lib.mkIf (config.settings.terminal.emulator.name == "wezterm") {
      home.packages = [pkgs.nerdfonts];
      settings.terminal.emulator.package = config.programs.wezterm.package;
      settings.terminal.emulator.exec = "${lib.getExe config.settings.terminal.emulator.package} start"; # or -e
      programs.wezterm = {
        enable = true;
        package = pkgs.wezterm;
        enableZshIntegration = true;
        colorSchemes = {
          base16 = with config.colorScheme.palette; {
            foreground = "#${base06}";
            background = "#${base00}";
            cursor_bg = "#${base06}";
            cursor_fg = "#${base00}";
            cursor_border = "#${base06}";
            selection_fg = "#${base00}";
            selection_bg = "#${base02}";
            scrollbar_thumb = "#${base03}";
            split = "#${base02}";
            compose_cursor = "${base07}";
            ansi = [
              "#${base00}"
              "#${base08}"
              "#${base0B}"
              "#${base0A}"
              "#${base0D}"
              "#${base0E}"
              "#${base0C}"
              "#${base06}"
            ];
            brights = [
              "#${base00}"
              "#${base08}"
              "#${base0B}"
              "#${base0A}"
              "#${base0D}"
              "#${base0E}"
              "#${base0C}"
              "#${base06}"
            ];
          };
        };
        extraConfig = ''
          local config = {
          	enable_wayland = true,
          	color_scheme = "base16",
          	window_background_opacity = 0.85,
          	use_fancy_tab_bar = false,
          	font = wezterm.font "JetBrainsMono Nerd Font",
          	font_size = 10,
          }
          return config
        '';
      };
    })
    (lib.mkIf (config.settings.terminal.emulator.name == "alacritty") {
      home.packages = [pkgs.nerdfonts];
      settings.terminal.emulator.package = config.programs.alacritty.package;
      settings.terminal.emulator.exec = "${lib.getExe config.settings.terminal.emulator.package} -e";
      programs.alacritty = {
        enable = true;
        settings.colors = with config.colorScheme.palette; {
          bright = {
            black = "0x${base00}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            white = "0x${base06}";
            yellow = "0x${base09}";
          };
          cursor = {
            cursor = "0x${base06}";
            text = "0x${base06}";
          };
          normal = {
            black = "0x${base00}";
            blue = "0x${base0D}";
            cyan = "0x${base0C}";
            green = "0x${base0B}";
            magenta = "0x${base0E}";
            red = "0x${base08}";
            white = "0x${base06}";
            yellow = "0x${base0A}";
          };
          primary = {
            background = "0x${base00}";
            foreground = "0x${base06}";
          };
        };
      };
    })
  ]);
}
