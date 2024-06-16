{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.networking = {
    bluetooth.enable = lib.mkEnableOption "Bluetooth";
    enable = lib.mkEnableOption "Networking";
    hostname = lib.mkStrOption "nixos";
    wifi.enable = lib.mkEnableOption "wifi";
    rtl8852be.enable = lib.mkEnableOption "rtl8852be tweaks";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.networking.bluetooth.enable) {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      settings.persist.root.cache = ["/var/lib/bluetooth"];
    })
    (lib.mkIf (config.settings.networking.enable) {
      networking.hostName = config.settings.networking.hostname;
    })
    (lib.mkIf (config.settings.networking.wifi.enable) {
      networking.networkmanager.enable = true;
      users.users."${config.settings.user.name}".extraGroups = ["networkmanager"];
      settings.networking.enable = true;
      # networking.networkmanager.wifi.backend = "iwd";
      # networking.wireless.iwd = {
      #   enable = true;
      #   settings.General.EnableNetworkConfiguration = true;
      # };
      settings.persist.root.cache = ["/etc/NetworkManager/system-connections"];
    })
    (lib.mkIf (config.settings.networking.rtl8852be.enable) {
      # Things to make realtek wifi card work
      # https://bbs.archlinux.org/viewtopic.php?pid=2102231#p2102231
      boot.extraModprobeConfig = ''
        options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
      '';
      # I don't think the below two things are necessary, but i've switched to intel ax210, so it doesn't matter ¯\_(ツ)_/¯
      boot.kernelModules = ["rtw89" "rtw89pci"];
      boot.kernelParams = [
        "pciehp.force=1"
      ];
    })
  ];
}
