{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixosModules
    ../../nixosModules/asahi # This causes problems when imported globally
  ];

  settings = {
    asahi.enable = true;
    greeter.enable = true;
    xserver.xwayland.enable = true;
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    # user.shell = pkgs.fish;
    user.shell = pkgs.zsh;
    networking = {
      enable = true;
      hostname = "mac-nix";
      wifi.enable = true;
      bluetooth.enable = true;
    };
    utils.enable = true;
    desktop.enable = true;
    tlp.enable = false;
    console = {
      font = "ter-u32n";
      keyMap = "no";
    };
    sops.enable = true;
  };

  # Enable XDG-desktop-portals (TODO: I think it's possible to do this in home)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [pkgs.xdg-desktop-portal-gtk];
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # programs.nix-ld.enable = true;

  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "geogebra"
      "1password"
      "1password-gui"
      "factorio"
      "factorio-demo"
    ];

  system.stateVersion = "24.05"; # Did you read the comment?

  fonts.packages = with pkgs; [
    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  i18n.inputMethod = {
    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [mozc];

    enabled = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      # TODO: probably set these settings with home-manager
      # settings = {
      #   globalOptions = {
      #     Behavior.ActiveByDefault = "True";
      #     Behavior.ShareInputState = "All";
      #   };
      #   addons = {
      #     classicui.TrayOutlineColor = "#282828";
      #     classicui.TrayTextColor = "#fbf1c7";
      #   };
      # };
    };
  };
}
