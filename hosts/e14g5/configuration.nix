{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
  outputs,
  ...
}: {
  imports = [
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
    user.shell = pkgs.zsh;
    networking = {
      enable = true;
      hostname = "e14g5-nix";
      wifi.enable = true;
      bluetooth.enable = true;
    };
    utils.enable = true;
    desktop.enable = true;
    #syncthing.enable = true;
    #syncthing.enableAllFolders = true;
    sound.enable = true;
    console = {
      font = "ter-u16n";
      keyMap = "no";
    };
    sops.enable = true;
  };

  services.thermald.enable = true;

  system.stateVersion = "24.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.logind.extraConfig = ''
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=suspend
  '';

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  settings.nix.unfree = [
    # "libfprint-2-tod1-goodix-550a"
    # "libfprint-2-tod1-goodix"
    # "libfprint-2-tod1-elan"
  ];

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      # driver = pkgs.libfprint-2-tod1-vfs0090;
      # driver = pkgs.libfprint-2-tod1-goodix-550a;
      # driver = pkgs.libfprint-2-tod1-goodix;
      # driver = pkgs.libfprint-2-tod1-elan;
      driver = outputs.packages.${pkgs.system}.libfprint-2-tod1-fpc;
    };
  };

  services.fwupd.enable = true;
}
