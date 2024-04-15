{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [./.];

  # https://github.com/tinted-theming/base16-schemes/
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
    monitors = [
      {
        name = "LVDS-1";
        wallpaper = ./wallpapers/wall13.jpg;
      }
    ];
    qt.enable = true;
    gtk.enable = true;
    wm = {
      ags.enable = true;
      hyprland = {
        enable = true;
        screenshots.enable = true;
      };
      sway = {
        enable = true;
      };
      avizo.enable = true;
      hypridle.enable = true;
      swaylock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
    };
    files.nemo.enable = true;
    zathura.enable = true;
    browser = {
      firefox.enable = true;
      firefox.newtab_image = ./wallpapers/wall10.jpg;
      qutebrowser.enable = true;
    };
    discord.vesktop.enable = true;
    terminal = {
      zsh = {
        enable = true;
        theme = "nanotech";
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

  wayland.windowManager.hyprland.settings.input.kb_options = lib.mkForce "ctrl:nocaps,altwin:swap_lalt_lwin";
  # wayland.windowManager.hyprland.settings."$mainMod" = lib.mkForce "ALT_L";
}
