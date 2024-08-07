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

  networking.hostId = "placeholder";

  settings = {
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    networking = {
      enable = true;
      hostname = "placeholder";
      wifi.enable = true;
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
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  system.stateVersion = "24.11";
}
