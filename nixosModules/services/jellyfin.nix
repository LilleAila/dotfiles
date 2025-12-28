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
    # TODO: proxy http://localhost:8096 to https://jellyfin.olai.dev
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
  };
}
