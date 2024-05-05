{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # It's done like this because disabling is not the same as doing nothing, for example on computers without nvidia, both should be false
  options.settings.nvidia.enable = lib.mkEnableOption "Enable nvidia";
  options.settings.nvidia.disable = lib.mkEnableOption "Disable nvidia";

  config = lib.mkMerge [
    (lib.mkIf config.settings.nvidia.disable (lib.mkAssert (!config.settings.nvidia.enable) "Nvidia cannot be both enabled and disabled" {
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
    }))
    (lib.mkIf config.settings.nvidia.enable (lib.mkAssert (!config.settings.nvidia.disable) "Nvidia cannot be both enabled and disabled" {
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
            enableOffloadCmd = true; # nvidia-offload command
          };
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      settings.nix.unfree = [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
      ];
    }))
  ];
}
