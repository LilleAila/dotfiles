{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.settings.nvidia.enable = lib.mkEnableOption "nvidia";

  config = lib.mkIf config.settings.nvidia.enable {
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
  };
}
