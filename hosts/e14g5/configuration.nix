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
    syncthing.enable = true;
    sound.enable = true;
    console = {
      font = "ter-u16n";
      keyMap = "no";
    };
    sops.enable = true;
    yubikey.enable = true;
  };

  services.thermald.enable = true;

  system.stateVersion = "24.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  systemd.services.disable_micmute_led = {
    description = "Disabled the microphone mute light on the keyboard";
    after = ["multi-user.target"];
    script = ''
      echo 0 | tee /sys/class/leds/platform::micmute/brightness
    '';
    wantedBy = ["multi-user.target"];
  };

  services.logind.extraConfig = ''
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=suspend
  '';

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # settings.nix.unfree = [
  #   # "libfprint-2-tod1-goodix-550a"
  #   # "libfprint-2-tod1-goodix"
  #   # "libfprint-2-tod1-elan"
  # ];
  #
  # services.fprintd = {
  #   enable = true;
  #   tod = {
  #     enable = true;
  #     # driver = pkgs.libfprint-2-tod1-vfs0090;
  #     # driver = pkgs.libfprint-2-tod1-goodix-550a;
  #     # driver = pkgs.libfprint-2-tod1-goodix;
  #     # driver = pkgs.libfprint-2-tod1-elan;
  #     driver = outputs.packages.${pkgs.system}.libfprint-2-tod1-fpc;
  #   };
  # };

  services.fwupd.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      RESTORE_THRESHOLDS_ON_BAT = 1;

      # Loud high-pitched fan noise under load, so a bit of power is sacrificed
      # https://linrunner.de/tlp/support/optimizing.html#reduce-power-consumption-fan-noise-on-ac-power
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
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
      CPU_MAX_PERF_ON_BAT = 40;

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      WOL_DISABLE = "Y";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
      DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
      DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi";
    };
  };
}
