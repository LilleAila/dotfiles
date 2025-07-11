{
  config,
  pkgs,
  stablePkgs,
  lib,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkDefault
    mkIf
    mkMerge
    ;
  cfg = config.settings.desktop;
in
{
  imports = [
    ./wm
    ./programs
  ];

  options.settings.desktop.enable = mkEnableOption "Default desktop configuration";
  options.settings.desktop.full.enable = mkEnableOption "Full desktop with more packages";

  config = mkMerge [
    (mkIf cfg.full.enable {
      settings = {
        desktop.enable = true;
        gaming = {
          enable = true;
          steam.enable = true;
        };
      };

      home.packages = with pkgs; [
        protonvpn-gui
        fluidsynth
        qsynth
        inkscape
        xournalpp
        krita
        kdePackages.kdenlive
        ffmpeg
        shotcut
        # (outputs.packages.${pkgs.system}.anki-nix-colors.override { inherit (config) colorScheme; }) # it's just too slow
        musescore
        calibre
        libgen-cli
        bottles
        # outputs.packages.${pkgs.system}.fhsenv
        pb_cli
        kicad
        bambu-studio
        freecad-wayland
        openscad
        # blender
        tigervnc
        qalculate-gtk
        wl-clipboard
        tor-browser
      ];

      settings.persist.home.directories = [
        ".config/MuseScore"
        ".local/share/MuseScore"
        ".config/obsidian" # Make it remember the opened vault
        ".local/share/bottles"
        "Calibre\ Library"
        ".config/calibre"
        "notes"
        ".config/xournalpp"
        ".local/share/kicad"
        ".config/kicad"
        ".config/BambuStudio"
        ".config/FreeCAD"
        ".config/OpenSCAD"
      ];

      settings.persist.home.cache = [
        ".cache/puppeteer" # Chrome is downloaded here
        ".cache/calibre"
        ".config/Proton"
        ".cache/Proton"
        ".cache/xournalpp"
        ".cache/kiced"
        ".config/cabal"
        ".cache/cabal"
        ".local/state/cabal"
        ".local/share/bambu-studio"
        ".cache/bambu-studio"
        ".local/share/FreeCAD"
        ".cache/FreeCAD"
        ".local/share/OpenSCAD"
        ".cache/tor project"
        ".tor project"
      ];

      settings.nix.unfree = [ "geogebra" ];
    })
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        _1password-gui
        bitwarden-desktop
        # (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (
        #   ps: with ps; [ plover-lapwing-aio ]
        # ))
        obsidian
        wf-recorder
      ];

      settings.nix.unfree = [
        "1password"
        "1password-gui"
        "obsidian"
      ];

      home.pointerCursor = {
        inherit (config.settings.cursor) package;
        inherit (config.settings.cursor) name;
        inherit (config.settings.cursor) size;
        gtk.enable = true;
      };

      # https://github.com/tinted-theming/base16-schemes/
      colorScheme = mkDefault inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
      home.file."colorscheme.txt".text = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (a: b: "${a}: #${b}") config.colorScheme.palette
      );
      settings = {
        gtk.enable = mkDefault true;
        qt.enable = mkDefault true;
        mimeApps.enable = true;
        cursor = {
          size = mkDefault 24;
          package = mkDefault (
            inputs.nix-cursors.packages.${pkgs.system}.bibata-modern-cursor.override {
              background_color = "#${config.colorScheme.palette.base00}";
              outline_color = "#${config.colorScheme.palette.base06}";
              accent_color = "#${config.colorScheme.palette.base00}";
              replace_crosshair = true;
            }
          );
          name = mkDefault "Bibata-Modern-Custom";
        };

        fcitx5.enable = mkDefault true;
        # blueman-applet.enable = lib.mkDefault true;
        wm = {
          hypridle.enable = mkDefault true;
          swaylock.enable = mkDefault true;
          # hyprlock.enable = mkDefault false;
          hyprpaper = {
            enable = mkDefault true;
            wallpaper = mkDefault (
              outputs.packages.${pkgs.system}.wallpaper.override { inherit (config) colorScheme; }
            );
          };

          waybar.enable = mkDefault true;
          swaync.enable = mkDefault true;
        };

        niri.enable = mkDefault true;

        plover.enable = mkDefault true;

        files.nemo.enable = mkDefault true;
        files.thunar.enable = mkDefault false;

        zathura.enable = mkDefault true;
        browser.firefox.enable = mkDefault true;
        browser.qutebrowser.enable = mkDefault true;

        discord.vesktop.enable = mkDefault true;

        kdeconnect.enable = mkDefault true;

        terminal = {
          zsh.enable = mkDefault true;
          zsh.theme = mkDefault "nanotech";
          utils.enable = mkDefault true;
          emulator.enable = mkDefault true;
          emulator.name = mkDefault "ghostty";
          neovim.enable = mkDefault true;
        };

        imageviewer.enable = mkDefault true;
        other.enable = mkDefault true;

        fonts =
          let
            nerdfonts = pkgs.nerd-fonts.jetbrains-mono;
          in
          {
            serif.package = mkDefault pkgs.dejavu_fonts;
            serif.name = mkDefault "DejaVu Serif";
            serif.variant = mkDefault "Book";
            sansSerif.package = mkDefault pkgs.dejavu_fonts;
            sansSerif.name = mkDefault "DejaVu Sans";
            sansSerif.variant = mkDefault "Book";
            monospace.package = mkDefault nerdfonts;
            monospace.name = mkDefault "JetBrainsMono Nerd Font";
            nerd.package = mkDefault nerdfonts;
            # "Nerd Font": icons expand with more space
            # "Nerd Font Mono": icons are all same size
            # "Nerd Font Propo": icons always take up their full size
            nerd.name = mkDefault "JetBrainsMono Nerd Font Propo";
            size = mkDefault 10;
          };

        persist.home.directories = [ ".config/plover" ];
        persist.home.cache = [ ".config/1Password" ];
      };

      settings.webapps.chromium = {
        Monkeytype = {
          icon = mkDefault "input-keyboard-symbolic";
          url = mkDefault "https://monkeytype.com";
        };
      };
    })
  ];
}
