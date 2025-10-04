{ config, lib, ... }:
let
  cfg = config.settings.caddy;
in
{
  options.settings.caddy = {
    enable = lib.mkEnableOption "caddy";
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
