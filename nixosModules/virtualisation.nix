{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.virtualisation.enable = lib.mkEnableOption "virtualisation";
  options.settings.nvidia.passthrough.enable = lib.mkEnableOption "passthrough";
  options.settings.nvidia.passthrough.ids = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "IDs of hardware to pass through with vfio";
  };

  config = lib.mkMerge [
    (lib.mkIf config.settings.virtualisation.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
      # dconf.settings = {
      #   "org/virt-manager/virt-manager/connections" = {
      #     autoconnect = ["qemu:///system"];
      #     uris = ["qemu:///system"];
      #   };
      # };
      users.users.${config.settings.user.name}.extraGroups = ["libvirtd"];
      environment.systemPackages = [pkgs.virt-manager];
      boot.kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
      ];
    })
    (lib.mkIf config.settings.nvidia.passthrough.enable {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen; # This not be necessary on other computers, but on my computer the GPU was in the same IOMMU group as other pci stuff that was not supposed to be passed through
      boot.kernelParams = [
        # These are device ids found with `lspci -nnk`.
        "vfio-pci.ids=${lib.concatStringsSep "," config.settings.nvidia.passthrough.ids}"
        "pcie_acs_override=downstream,multifunction" # Make GPU be in a different IOMMU group
      ];
      boot.initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
      boot.extraModprobeConfig = ''
        softdep nvidia pre: vfio-pci
        softdep drm pre: vfio-pci
        softdep nouveau pre: vfio-pci
      '';
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" "i2c_nvidia_gpu"];
      virtualisation.spiceUSBRedirection.enable = true;

      # Looking glass
      environment.systemPackages = [pkgs.looking-glass-client];
      systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 ${config.settings.user.name} libvirtd -"
      ];

      settings.virtualisation.enable = true;
    })
  ];
}
