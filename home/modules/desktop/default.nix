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
      settings.desktop.enable = true;
      home.packages = with pkgs; [
        protonvpn-gui
        fluidsynth
        qsynth
        inkscape
        xournalpp
        krita
        libreoffice
        kdenlive
        ffmpeg
        # (outputs.packages.${pkgs.system}.anki-nix-colors.override { inherit (config) colorScheme; }) # it's just too slow
        musescore
        stablePkgs.calibre
        libgen-cli
        k2pdfopt
        bottles
        outputs.packages.${pkgs.system}.fhsenv
        pb_cli
      ];

      settings.persist.home.directories = [
        ".config/MuseScore"
        ".local/share/MuseScore"
        ".config/obsidian" # Make it remember the opened vault
        ".local/share/bottles"
        "Calibre\ Library"
        ".config/calibre"
        "notes"
      ];

      settings.persist.home.cache = [
        ".cache/puppeteer" # Chrome is downloaded here
        ".cache/calibre"
        ".config/Proton"
      ];

      settings.nix.unfree = [ "geogebra" ];
    })
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        _1password-gui
        (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (
          ps: with ps; [ plover-lapwing-aio ]
        ))
        obsidian
        handbrake
        wf-recorder
      ];

      settings.nix.unfree = [
        "1password"
        "1password-gui"
        "obsidian"
      ];

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

        fcitx5.enable = mkDefault false;
        # blueman-applet.enable = lib.mkDefault true;
        # syncthing.tray.enable = mkDefault true;
        wm = {
          ags.enable = mkDefault true;
          hyprland.enable = mkDefault true;
          sway.enable = mkDefault false;
          avizo.enable = mkDefault false;
          hypridle.enable = mkDefault true;
          swaylock.enable = mkDefault true;
          # hyprlock.enable = mkDefault false;
          hyprpaper.enable = mkDefault true;
          hyprpaper.wallpaper = mkDefault (
            outputs.packages.${pkgs.system}.wallpaper.override { inherit (config) colorScheme; }
          );
          mako.enable = mkDefault false;
          wlogout.enable = mkDefault false;
          espanso.enable = mkDefault false;
        };

        files.nemo.enable = mkDefault true;
        files.thunar.enable = mkDefault false;

        zathura.enable = mkDefault true;
        browser.firefox.enable = mkDefault true;
        browser.firefox.newtab_image = mkDefault (
          outputs.packages.${pkgs.system}.wallpaper.override rec {
            inherit (config) colorScheme;
            logo = false;
            accent = colorScheme.palette.base09;
          }
        );
        # browser.qutebrowser.enable = mkDefault true;

        discord.vesktop.enable = mkDefault true;
        discord.dissent.enable = mkDefault false;

        emacs.enable = mkDefault false;

        terminal = {
          zsh.enable = mkDefault true;
          zsh.theme = mkDefault "nanotech";
          fish.enable = mkDefault false;
          utils.enable = mkDefault true;
          emulator.enable = mkDefault true;
          emulator.name = mkDefault "kitty";
          neovim.enable = mkDefault true;
        };

        imageviewer.enable = mkDefault true;
        other.enable = mkDefault true;

        fonts =
          let
            nerdfonts = pkgs.nerdfonts.override {
              fonts = [
                "JetBrainsMono"
                "Iosevka"
              ];
            };
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
        # CSTimer = {
        #   icon = mkDefault "timer-symbolic";
        #   url = mkDefault "https://cstimer.net";
        # };
      };

      home.sessionVariables."PLOVER_UINPUT_LAYOUT" = lib.mkDefault "no";
    })
  ];
}
