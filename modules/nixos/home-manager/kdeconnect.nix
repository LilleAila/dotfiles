{ lib, ... }:
{
  flake.modules.nixos.kdeconnect =
    { config, ... }:
    {
      config = lib.mkIf config.hm.settings.kdeconnect.enable {
        networking.firewall = {
          allowedTCPPortRanges = [
            {
              from = 1714;
              to = 1764;
            }
          ];
          allowedUDPPortRanges = [
            {
              from = 1714;
              to = 1764;
            }
          ];
        };
      };
    };
}
