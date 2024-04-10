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

    # i18n.inputMethod = {
    #   enabled = "ibus";
    #   ibus.engines = with pkgs.ibus-engines; [
    #     uniemoji
    #     mozc
    #   ];
    # };

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
