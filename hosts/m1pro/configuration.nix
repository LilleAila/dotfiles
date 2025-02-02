{
  config,
  lib,
  pkgs,
  globalSettings,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  # Apple silicon module is loaded in flake.nix
  hardware.asahi = {
    peripheralFirmwareDirectory = ./firmware;
    useExperimentalGPUDriver = true;
  };

  boot.kernelParams = [
    "apple_dcp.show_notch=1"
    "hid_apple.fnmode=2"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  settings = {
    greeter.enable = true;
    greeter.command = "sway";
    xserver.xwayland.enable = true;
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    user.shell = pkgs.zsh;
    networking = {
      enable = true;
      hostname = "m1pro-nix";
      wifi.enable = true;
      bluetooth.enable = true;
    };
    console = {
      font = "ter-v32n";
      keyMap = "no";
    };
    sound.enable = true;

    sops.enable = true;
    gpg.enable = true;
    yubikey.enable = true;
    virtualisation.enable = true;
    # docker.enable = true;
    distrobox.enable = true;
    syncthing.enable = true;

    impermanence.enable = true;

    utils.enable = true;
    desktop.enable = true;
    sway.enable = true;
  };

  networking.networkmanager.wifi.backend = "iwd";
  hardware.graphics.enable32Bit = lib.mkForce false;

  time.timeZone = "Europe/Oslo";

  system.stateVersion = "25.05";
}
