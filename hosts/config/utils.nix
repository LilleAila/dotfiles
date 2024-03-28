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

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1"; # Fix electron apps on wayland
    };

    # Disable power button (handle in window manager)
    services.logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    # Enable some packages
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      vim
      wget
      neovim
      home-manager
      git
      pciutils
    ];
  };
}
