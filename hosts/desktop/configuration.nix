{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
  keys,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "7dbd1705";

  settings = {
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    networking = {
      enable = true;
      hostname = "nixdesktop";
      wifi.enable = true;
      bluetooth.enable = true;
    };
    utils.enable = true;
    console = {
      font = "ter-u16n";
      keyMap = "no";
    };
    sops.enable = true;

    ssh.enable = true;
    ssh.keys = with keys.ssh; [
      e14g5.public
      t420.public
    ];

    zfs.enable = true;
    zfs.encryption = false;
    zfs.snapshots = true;
    impermanence.enable = true;

    greeter.enable = true;
    greeter.command = "sway";
    xserver.xwayland.enable = true;
    desktop.enable = true;
    sway.enable = true;
    syncthing.enable = true;
    sound.enable = true;
    gpg.enable = true;
    yubikey.enable = true;
    virtualisation.enable = true;
    searx.enable = true;
  };

  system.stateVersion = "24.11";
}
