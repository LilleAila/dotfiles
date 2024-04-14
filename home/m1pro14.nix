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
        name = "eDP-1";
        width = 3024; # 1512
        height = 1890; # 945
        refreshRate = 60;
        x = 0;
        y = 0;
        scale = 2;
        enable = true;
        wallpaper = ./wallpapers/wall3.jpg;
      }
      # Use keybindings with wlr-randr to define external displays, reload with mod V
      # TODO: Make this a string instead so that I can set preferred / auto (if width or height == null then preferred, same for position but auto)
      {
        name = "HDMI-A-1";
        width = 2560;
        height = 1440;
        # width = 1920;
        # height = 1080;
        # rotation = 1;
        # refreshRate = 75;
        x = -524;
        y = -1440;
        # x = -1080;
        # y = -1100;
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
        enable = true;
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

  # Local shell aliases
  home.shellAliases = {
    bat-fullcharge = "echo 100 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    bat-limit = "echo 80 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
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
		(import ../pkgs/box64.nix { inherit pkgs stdenv; })
		# (pkgs.callPackage ../pkgs/factorio.nix { releaseType = "demo" })
	];
}
