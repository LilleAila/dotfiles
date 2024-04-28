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
  ];

  settings = {
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
      hostname = "t420-nix";
      wifi.enable = true;
      bluetooth.enable = false;
    };
    utils.enable = true;
    desktop.enable = true;
    tlp.enable = true;
    console = {
      font = "ter-u16n";
      keyMap = "no";
    };
    sops.enable = true;
    nix.unfree = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };

  # Enable steam
  # programs.steam = {
  #   enable = true;
  #   package = pkgs.steam;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  # };

  system.stateVersion = "24.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.initrd.luks.devices."luks-88c6adff-e723-48ab-8595-5a0b7975f623".device = "/dev/disk/by-uuid/88c6adff-e723-48ab-8595-5a0b7975f623";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # https://github.com/NixOS/nixos-hardware
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # TODO: in its own file
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
