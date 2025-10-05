{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.settings.jellyfin;
in
{
  options.settings.jellyfin.enable = lib.mkEnableOption "jellyfin";

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # settings.persist.root.directories = [
    #   config.services.jellyfin.dataDir
    # ];

    environment.persistence."/persist" = {
      directories = [
        {
          directory = config.services.jellyfin.dataDir;
          mode = "664";
          inherit (config.services.jellyfin) user group;
        }
      ];
    };

    settings.cloudflared.enable = true;

    # sops.secrets."tunnels/jellyfin" = {
    #   owner = "cloudflared";
    #   group = "cloudflared";
    # };

    services.cloudflared.tunnels."e00ace6c-e320-4a93-abbd-78e3d6477754" = {
      credentialsFile = config.sops.secrets."tunnels/jellyfin".path;
      default = "http_status:404";
      ingress = {
        "jellyfin.olai.dev" = "http://localhost:8096";
      };
    };
  };
}
