{ lib, ... }:
{
  flake.modules.nixos.caddy =
    {
      config,
      pkgs,
      ...
    }:
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

          # See https://wiki.nixos.org/wiki/Caddy#Plug-ins
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/mholt/caddy-l4@v0.0.0-20251001194302-2e3e6cf60b25" ];
            hash = "sha256-Yi1lILoYpFenFJKJDO4JocM7oXxdltLELPB3q0qCerk=";
          };
        };

        environment.systemPackages = [
          config.services.caddy.package
        ];

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
    };
}
