{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.networking = {
    bluetooth.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };
    wifi.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.networking.bluetooth.enable) {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
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
    })
  ];
}
