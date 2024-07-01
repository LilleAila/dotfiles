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
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    sops.secrets."nextcloud/cloudflare" = {
      neededForUsers = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "olai.solsvik@gmail.com"; # TODO: make this a global option from flake.nix
      certs."nextcloud.olai.dev" = {
        dnsProvider = "cloudflare";
        webroot = null;
        environmentFile = config.sops.secrets."nextcloud/cloudflare".path;
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      virtualHosts = {
        "nextcloud.olai.dev" = {
          enableACME = true;
          acmeRoot = null;
          forceSSL = true;
          # addSSL = true;
          locations."/" = {
            proxyPass = "http://0.0.0.0:8080";
            proxyWebsockets = true;
          };
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
      hostName = "nextcloud.olai.dev";
      # nginx.enable = true;
      https = true;
      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "01:00:00";

      settings = {
        overwriteprotocol = "https";
        # config_is_read_only = "true";
        default_phone_region = "NO";
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
