{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "usb_storage" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems.btrfs = true;

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/c9276aa3-8ab7-4429-a058-43cd0104f8ce";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/3f4d4d6c-476e-4dd8-9ee4-593734bc6daf";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/3f4d4d6c-476e-4dd8-9ee4-593734bc6daf";
      fsType = "btrfs";
      options = [ "subvol=tmp" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/3f4d4d6c-476e-4dd8-9ee4-593734bc6daf";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist/cache" =
    { device = "/dev/disk/by-uuid/3f4d4d6c-476e-4dd8-9ee4-593734bc6daf";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=cache" "compress=zstd" "noatime" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/3f4d4d6c-476e-4dd8-9ee4-593734bc6daf";
      fsType = "btrfs";
      options = [ "subvol=cache" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/38BA-11EE";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
