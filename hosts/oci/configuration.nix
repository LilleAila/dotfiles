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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  settings = {
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    networking = {
      enable = true;
      hostname = "oci-nix";
    };
    utils.enable = true;
    console = {
      font = "ter-u32n";
      keyMap = "no";
    };
    sops.enable = true;
    ssh.enable = true;
    ssh.keys = with keys.ssh; [
      e14g5.public
      t420.public
      desktop.public
      m4air-darwin.public
      pixel8a.public
    ];

    caddy.enable = true;
    syncthing.enable = true;
    webdav.enable = true;
    calibre-web.enable = true;
    minecraft.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  environment.systemPackages = with pkgs; [
    # Terminfo for ssh
    kitty
    ghostty
  ];

  # To access the GUI, use SSH tunneling: `ssh -L 9999:localhost:8384 olai@158.179.205.169`, and then go to 127.0.0.1:9999 on the local machine
  # docs: https://docs.syncthing.net/users/firewall.html#tunneling-via-ssh

  system.stateVersion = "24.05"; # Did you read the comment?
}
