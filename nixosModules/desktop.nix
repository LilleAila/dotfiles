{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.desktop.enable = lib.mkEnableOption "misc. gui utils";

  config = lib.mkIf (config.settings.desktop.enable) {
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    services.seatd.enable = true;
    programs.dconf.enable = true;
    programs.xfconf.enable = true;
    services.gvfs.enable = true;
    settings.persist.home.cache = [ ".local/share/gvfs-metadata" ];
    settings.persist.home.directories = [
      ".cache/dconf"
      ".config/dconf"
      "qmk_firmware"
    ];
    # services.printing.enable = true;

    hardware.keyboard.qmk.enable = true;
    # Allow read/write to ttyACM0 serial port
    # Allow uinput as non-root user (in input group)
    services.udev.extraRules = ''
      KERNEL=="ttyACM0", MODE="0666"
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';

    environment.sessionVariables.NIXOS_ACTIVE_SPECIALISATION = lib.mkDefault "default";

    # qt = {
    #   enable = true;
    #   platformTheme = "qt5ct";
    # };

    # Required for qt5ct to work when launching apps from ags (more specifically, through hyprland)
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

    xdg.portal = {
      enable = true;
      # wlr.enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-gtk ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    fonts.packages = with pkgs; [
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
      noto-fonts
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

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1"; # Fix electron apps on wayland
    };

    # Disable power button (handle in window manager)
    services.logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    # == Authentication stuff ==
    # Allow authentication in swaylock
    security.pam.services.swaylock = { };

    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
