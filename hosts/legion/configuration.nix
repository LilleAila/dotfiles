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
    sound.enable = true;
    console = {
      font = "ter-u16n";
      keyMap = "no";
    };
    sops.enable = true;
    nix.unfree = [
      # "steam"
      # "steam-original"
      # "steam-run"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "1password"
      "1password-gui"
    ];
  };

  system.stateVersion = "24.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.initrd.luks.devices."luks-bb382811-0530-49f8-927f-a7e18e048288".device = "/dev/disk/by-uuid/bb382811-0530-49f8-927f-a7e18e048288";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "quiet"
    "splash"
  ];

  services.tlp = {
    enable = true;
    settings = {
      DEVICE_TO_DISABLE_ON_STARTUP = "bluetooth";

      # ideapad_laptop does not support excact charge thresholds. `1` is a dummy value for "conservation mode"
      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = 1;
      RESTORE_THRESHOLDS_ON_BAT = 1;

      MAX_LOST_WORK_SECS_ON_BAT = 15; # Make powertop happy

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      INTEL_GPU_MIN_FREQ_ON_AC = 350;
      INTEL_GPU_MAX_FREQ_ON_AC = 1050;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1050;
      INTEL_GPU_MIN_FREQ_ON_BAT = 350;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 800;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      WOL_DISABLE = "Y";

      DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wlan";
      DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wlan";

      USB_AUTOSUSPEND = 1;
    };
  };

  # Nvidia GPU disabled in BIOS for more better battery life
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   prime = {
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true; # nvidia-offload command
  #     };
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  # };

  # https://github.com/NixOS/nixos-hardware
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
