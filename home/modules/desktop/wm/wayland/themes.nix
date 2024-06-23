{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  nix-colors-lib = inputs.nix-colors.lib.contrib {inherit pkgs;};
in {
  options.settings = {
    qt.enable = lib.mkEnableOption "qt";
    gtk.enable = lib.mkEnableOption "gtk";
    cursor.package = lib.mkOption {type = lib.types.package;};
    cursor.name = lib.mkOption {type = lib.types.str;};
    cursor.size = lib.mkOption {type = lib.types.int;};
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.qt.enable) {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.package = with pkgs; [adwaita-qt adwaita-qt6];
      };
      home.packages = with pkgs; [
        libsForQt5.qt5.qtwayland
        kdePackages.qtwayland
      ];
      home.file.".config/qt5ct/colors/${config.colorScheme.slug}.conf".text = lib.generators.toINI {} {
        ColorScheme = let
          mkScheme = colors: lib.concatStringsSep ", " (map (color: "#ff${color}") colors);
        in
          with config.colorScheme.palette; {
            active_colors = mkScheme [
              base06 # Window text
              base00 # Button background
              base06 # Bright
              base05 # Less bright
              base01 # Dark
              base02 # Less dark
              base06 # Normal text
              base07 # Bright text
              base06 # Button text
              base00 # Normal background
              base00 # Window
              base00 # Shadow
              base02 # Highlight
              base05 # Highlighted text
              base0D # Link
              base0E # Visited link
              base01 # Alternate background
              base01 # Default
              base01 # Tooltip background
              base06 # Tooltip text
              base05 # Placeholder text
            ];

            inactive_colors = mkScheme [
              base04 # Window text
              base00 # Button background
              base05 # Bright
              base04 # Less bright
              base01 # Dark
              base02 # Less dark
              base04 # Normal text
              base05 # Bright text
              base04 # Button text
              base00 # Normal background
              base00 # Window
              base00 # Shadow
              base02 # Highlight
              base05 # Highlighted text
              base0D # Link
              base0E # Visited link
              base01 # Alternate background
              base01 # Default
              base01 # Tooltip background
              base05 # Tooltip text
              base04 # Placeholder text
            ];

            disabled_colors = mkScheme [
              base04 # Window text
              base00 # Button background
              base04 # Bright
              base03 # Less bright
              base00 # Dark
              base01 # Less dark
              base04 # Normal text
              base05 # Bright text
              base04 # Button text
              base00 # Normal background
              base00 # Window
              base00 # Shadow
              base02 # Highlight
              base05 # Highlighted text
              base0D # Link
              base0E # Visited link
              base01 # Alternate background
              base01 # Default
              base01 # Tooltip background
              base04 # Tooltip text
              base03 # Placeholder text
            ];
          };
      };
      home.file.".config/qt5ct/qt5ct.conf".text = lib.generators.toINI {} {
        Appearance = {
          color_scheme_path = "${config.home.homeDirectory}/.config/qt5ct/colors/${config.colorScheme.slug}.conf";
          custom_palette = true;
          icon_theme = "Papirus-Dark"; # TODO: make option and sync with gtk icon theme
          standard_dialogs = "default";
          # style = "Fusion";
          style = "Adwaita-Dark";
        };

        Fonts = {
          # 10 is the font size, idk about the rest of the numbers
          # TODO: use the config options
          fixed = "\"JetBrains Mono,10,-1,5,50,0,0,0,0,0,Regular\"";
          general = "\"DejaVu Sans,10,-1,5,50,0,0,0,0,0,Book\"";
        };

        Troubleshooting = {
          force_raster_widgets = 1;
          ignored_applications = "@Invalid()";
        };

        Interface = {
          cursor_flash_time = 1200;
          double_click_interval = 400;
          menus_have_icons = true;
          show_shortcuts_in_context_menus = true;
          gui_effects = "@Invalid()";
          stylesheets = "@Invalid()";
          buttonbox_layout = 3; # GNOME dialog button layout
          toolbutton_style = 4; # Follow the application style
          activate_item_on_single_click = 1; # ... - i think that means let the application decide
          dialog_buttons_have_icons = 1; # ...
          underline_shortcut = 1; # ...
          wheel_scroll_lines = 3;
          keyboard_scheme = 2; # X11
        };
      };
    })
    (lib.mkIf (config.settings.gtk.enable) {
      gtk = {
        enable = true;
        # Tested schene with `nix-shell -p awf --run awf-gtk3`
        theme.package = import ./gtk-theme.nix {inherit pkgs;} {scheme = config.colorScheme;};
        theme.name = "${config.colorScheme.slug}";
        iconTheme.package = pkgs.papirus-icon-theme;
        iconTheme.name = "Papirus-Dark";
      };
    })
    (lib.mkIf (config.settings.wm.hyprland.enable) {
      home.pointerCursor = {
        package = config.settings.cursor.package;
        name = config.settings.cursor.name;
        size = config.settings.cursor.size;
        gtk.enable = true;
      };
      # wayland.windowManager.hyprland.settings = {
      #   exec-once = [
      #     "hyprctl setcursor \"${config.settings.cursor.name}\" ${toString config.settings.cursor.size} &"
      #   ];
      # };
    })
  ];
}
