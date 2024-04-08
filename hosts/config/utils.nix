{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.utils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable various general utilities";
  };

  config = lib.mkIf (config.settings.utils.enable) {
    environment.shells = [pkgs.zsh pkgs.fish];
    programs.zsh.enable = true;
    programs.fish.enable = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.fstrim.enable = true;
    services.upower.enable = true;
    services.seatd.enable = true;
    programs.dconf.enable = true;
    programs.xfconf.enable = true;
    services.gvfs.enable = true;
    # services.printing.enable = true;

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

    # Enable some packages
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      vim
      wget
      neovim
      home-manager
      git
      pciutils
      dotool
      wtype
    ];
  };
}
