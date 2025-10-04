{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options.settings.calibre-web.enable = lib.mkEnableOption "calibre-web";

  config = lib.mkIf config.settings.calibre-web.enable {
    sops.secrets."tunnels/calibre" = {
      owner = "cloudflared";
      group = "cloudflared";
    };

    # services.cloudflared.tunnels.${(import ../../secrets/tokens.nix).calibre.id} = {
    #   credentialsFile = config.sops.secrets."tunnels/calibre".path;
    #   default = "http_status:404";
    #   ingress = {
    #     "calibre.olai.dev" = "http://${config.services.calibre-web.listen.ip}:${toString config.services.calibre-web.listen.port}";
    #   };
    # };

    services.caddy.virtualHosts."calibre.olai.dev".extraConfig = ''
      reverse_proxy http://${config.services.calibre-web.listen.ip}:${toString config.services.calibre-web.listen.port}
    '';

    services.calibre-web = {
      enable = true;
      listen = {
        ip = "127.0.0.1";
        port = 8083;
      };
      dataDir = "calibre-web"; # /var/lib/calibre-web
      options = {
        # calibreLibrary = "/home/${config.settings.user.name}/Calibre Library";
        calibreLibrary = "/calibre";
        enableKepubify = true;
        # enableBookConversion = true; # Broken on arm
        enableBookUploading = false;
      };
    };

    # For some reason calibre-web doesn't like it being in /home, likely because of ownership
    # Make sure this folder is still owned by olai:users, even though it's placed in root
    # It may need a restart to properly apply the synced changes
    services.syncthing.settings.folders."Calibre Library" = {
      path = lib.mkForce "/calibre";
      # type = "receiveonly";
    };
  };
}
