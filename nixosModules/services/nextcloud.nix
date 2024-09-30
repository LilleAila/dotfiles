/*
  https://jacobneplokh.com/how-to-setup-nextcloud-on-nixos/
  https://mich-murphy.com/configure-nextcloud-nixos/
*/
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  options.settings.nextcloud.enable = lib.mkEnableOption "nextcloud";

  config = lib.mkIf config.settings.nextcloud.enable {
    # # Needed for ACME
    # networking.firewall.allowedTCPPorts = [
    #   80
    #   443
    # ];
    # networking.firewall.allowedUDPPorts = [
    #   80
    #   443
    # ];
    #
    # sops.secrets."nextcloud/cloudflare" = {
    #   neededForUsers = true;
    # };
    #
    # users.users.nginx.extraGroups = [ "acme" ];
    #
    # services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    #   enableACME = true;
    #   forceSSL = true;
    # };
    #
    # security.acme = {
    #   acceptTerms = true;
    #   defaults.email = "olai.solsvik@gmail.com";
    #   # certs.${config.services.nextcloud.hostName} = {
    #   #   dnsProvider = "cloudflare";
    #   #   webroot = null;
    #   #   environmentFile = config.sops.secrets."nextcloud/cloudflare".path;
    #   # };
    # };

    sops.secrets."tunnels/nextcloud" = {
      owner = "cloudflared";
      group = "cloudflared";
    };

    services.cloudflared = {
      enable = true;
      tunnels.${(import ../../secrets/tokens.nix).nextcloud.id} = {
        credentialsFile = config.sops.secrets."tunnels/nextcloud".path;
        default = "http_status:404";
        ingress = {
          "nextcloud.olai.dev" = "http://localhost:80";
        };
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          # ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
          ensureDBOwnership = true;
          ensureClauses = {
            superuser = true;
            replication = true;
            login = true;
            "inherit" = true;
            createrole = true;
            createdb = true;
            bypassrls = true;
          };
        }
      ];
    };

    sops.secrets."nextcloud/password" = {
      owner = "nextcloud";
    };
    sops.secrets."nextcloud/db-password" = {
      owner = "nextcloud";
    };

    services.nextcloud = {
      enable = true;
      hostName = "127.0.0.1";
      https = false;
      configureRedis = true;

      # Could configure apps declaratively, but it's easier to install imperatively
      # Also, some apps are not available in nixpkgs
      # https://wiki.nixos.org/wiki/Nextcloud#Apps

      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "01:00:00";

      settings = {
        # config_is_read_only = "true";
        overwriteprotocol = "https";
        default_phone_region = "NO";
        trusted_domains = [ "nextcloud.olai.dev" ];
      };

      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbpassFile = "${config.sops.secrets."nextcloud/db-password".path}";

        adminpassFile = "${config.sops.secrets."nextcloud/password".path}";
        adminuser = "admin";
      };
    };

    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };
}
