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
    wallpaper = ./wallpapers/wall13.jpg;
    monitors = [
      {
        name = "eDP-1";
        width = 3024;
        height = 1890;
        refreshRate = 60;
        x = 0;
        y = 0;
        scale = 2;
        enable = true;
      }
      {
        name = "HDMI-A-1";
        width = 2560;
        height = 1440;
        refreshRate = 144;
        x = -524;
        y = -1440;
        scale = 1;
        enable = true;
      }
    ];
    wm = {
      ags.enable = true;
      hyprland = {
        enable = true;
        useLegacyRenderer = true;
      };
      avizo.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
      wlogout.enable = true;
    };
    browser = {
      firefox.enable = true;
    };
    discord = {
      enable = true;
      hyprland.enable = true;
    };
    emacs.enable = true;
    terminal = {
      zsh = {
        enable = true;
        theme = "nanotech";
        utils.enable = true;
      };
      kitty.enable = true;
      neovim.enable = true;
    };
  };
}
