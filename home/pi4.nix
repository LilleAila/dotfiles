{
  config,
  pkgs,
  inputs,
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
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        # rotation = 1;
        refreshRate = 75;
        x = 0;
        y = 0;
        scale = 1;
        enable = true;
        wallpaper = ./wallpapers/wall18.jpg;
      }
    ];
    qt.enable = true;
    gtk.enable = true;
    wm = {
      ags.enable = true;
      hyprland = {
        enable = true;
        # useLegacyRenderer = true;
        screenshots.enable = true;
      };
      sway = {
        enable = false;
      };
      avizo.enable = true;
      hypridle.enable = true;
      # hyprlock.enable = true;
      swaylock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
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
}
