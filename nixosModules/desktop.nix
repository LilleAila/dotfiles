{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.desktop.enable = lib.mkEnableOption "misc. gui utils";

  config = lib.mkIf (config.settings.desktop.enable) {
    services.seatd.enable = true;
    programs.dconf.enable = true;
    programs.xfconf.enable = true;
    services.gvfs.enable = true;
    # services.printing.enable = true;

    # Enable XDG-desktop-portals (TODO: I think it's possible to do this in home)
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      configPackages = [pkgs.xdg-desktop-portal-gtk];
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
      };
    };

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

    xdg.autostart.enable = true;

    hardware.keyboard.qmk.enable = true;
    # Allow read/write to ttyACM0 serial port
    # Allow dotool as non-root user (in input group)
    services.udev.extraRules = ''
      KERNEL=="ttyACM0", MODE="0666"
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1"; # Fix electron apps on wayland
    };

    # Disable power button (handle in window manager)
    services.logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    # Allow authentication in swaylock
    security.pam.services.swaylock = {};
  };
}
