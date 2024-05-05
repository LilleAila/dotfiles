{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.virtualisation.enable = lib.mkEnableOption "virtualisation";
  options.settings.virtualisation.passthrough.enable = lib.mkEnableOption "passthrough";

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
    (lib.mkIf config.settings.virtualisation.passthrough.enable {
      /*
      Useful resources:
      - https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
      - https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
      - https://alexbakker.me/post/nixos-pci-passthrough-qemu-vfio.html
      - https://github.com/bryansteiner/gpu-passthrough-tutorial
      - https://looking-glass.io/docs/B6/install/
      */
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen; # This not be necessary on other computers, but on my computer the GPU was in the same IOMMU group as other pci stuff that was not supposed to be passed through
      boot.kernelParams = [
        # These are device ids found with `lspci -nnk`.
        "vfio-pci.ids=10de:1f11,10de:10f9"
        "pcie_acs_override=downstream,multifunction"
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
