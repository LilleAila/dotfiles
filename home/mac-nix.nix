{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./.
    inputs.nix-index-database.hmModules.nix-index
  ];

  # https://github.com/tinted-theming/base16-schemes/
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
    monitors = [
      {
        name = "eDP-1";
        wallpaper = ./wallpapers/wall3.jpg;
      }
      {
        name = "HDMI-A-1";
        wallpaper = ./wallpapers/wall18.jpg;
      }
    ];
    qt.enable = true;
    gtk.enable = true;
    cursor = {
      size = 24;
      package = inputs.nix-cursors.packages.${pkgs.system}.bibata-original-cursor.override {
        background_color = "#${config.colorScheme.palette.base00}";
        outline_color = "#${config.colorScheme.palette.base06}";
        accent_color = "#${config.colorScheme.palette.base00}";
        replace_crosshair = true;
      };
      name = "Bibata-Original-Custom";
    };
    wm = {
      ags.enable = true;
      hyprland = {
        enable = true;
        # useLegacyRenderer = true;
        screenshots.enable = true;
      };
      sway = {
        enable = true;
      };
      avizo.enable = true;
      hypridle.enable = true;
      # hyprlock.enable = true;
      swaylock.enable = true;
      hyprpaper.enable = true;
      mako.enable = false; # Replaced with ags
      wlogout.enable = false; # Replaced with ags
    };
    files = {
      nemo.enable = true;
      thunar.enable = false;
    };
    zathura.enable = true;
    browser = {
      firefox.enable = true;
      firefox.newtab_image = ./wallpapers/wall1.png;
      qutebrowser.enable = true;
    };
    discord = {
      vesktop.enable = true;
      dissent.enable = false;
    };
    emacs.enable = false;
    terminal = {
      zsh = {
        enable = true;
        theme = "nanotech";
      };
      fish = {
        enable = true;
      };
      utils.enable = true;
      emulator = {
        enable = true;
        name = "kitty";
      };
      neovim.enable = true;
    };
    imageviewer.enable = true;
    other.enable = true;
    fonts = let
      jetbrains_nerd = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
    in {
      serif.package = pkgs.dejavu_fonts;
      serif.name = "DejaVu Serif";
      sansSerif.package = pkgs.dejavu_fonts;
      sansSerif.name = "DejaVu Sans";
      monospace.package = jetbrains_nerd;
      monospace.name = "JetBrainsMono Nerd Font";
      nerd.package = jetbrains_nerd;
      nerd.name = "JetBrainsMono Nerd Font";
      size = 10;
    };
  };

  # Local shell aliases
  home.shellAliases = {
    bat-fullcharge = "echo 100 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    bat-limit = "echo 80 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    osbuild = lib.mkForce "nh os switch -- --impure";
  };

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-gtk
  #     fcitx5-configtool
  #     fcitx5-m17n
  #     fcitx5-mozc
  #   ];
  # };

  home.packages = with pkgs; [
    outputs.packages.${pkgs.system}.box64
    outputs.packages.${pkgs.system}.fhsenv

    _1password-gui-beta
    handbrake

    (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (ps:
      with ps; [
        plover-uinput
      ]))

    geogebra6
    lmms
    musescore
    inkscape
  ];

  home.sessionVariables."PLOVER_UINPUT_LAYOUT" = "no";
}
