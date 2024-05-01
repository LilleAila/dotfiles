{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
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
    # user.shell = pkgs.fish;
    user.shell = pkgs.zsh;
    networking = {
      enable = true;
      hostname = "legion-nix";
      wifi.enable = true;
      bluetooth.enable = true;
    };
    utils.enable = true;
    desktop.enable = true;
    tlp.enable = false; # TODO: different profiles
    console = {
      font = "ter-u16n";
      keyMap = "no";
    };
    sops.enable = true;
    nix.unfree = [
      "steam"
      "steam-original"
      "steam-run"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "1password"
      "1password-gui"
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
  boot.initrd.luks.devices."luks-bb382811-0530-49f8-927f-a7e18e048288".device = "/dev/disk/by-uuid/bb382811-0530-49f8-927f-a7e18e048288";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

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
