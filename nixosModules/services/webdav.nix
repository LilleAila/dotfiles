{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.settings.webdav.enable = lib.mkEnableOption "webdav";

  config = lib.mkIf config.settings.webdav.enable {
    sops.secrets."webdav/password" = {
      owner = "webdav";
      group = "webdav";
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."webdav.olai.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          # proxyPass = "http://158.179.205.169:8080";
          proxyPass = "http://127.0.0.1:8080";
          # proxyPass = "http://0.0.0.0:8080";
          # proxyPass = "http://[::1]:8080";
          extraConfig = ''
            proxy_ssl_server_name on;
            proxy_pass_header Authorization;
          '';
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "olai.solsvik@gmail.com";
    };

    # idk which ones are *actually* needed
    networking.firewall.allowedTCPPorts = [8080 443 80];
    networking.firewall.allowedUDPPorts = [8080 443 80];

    services.webdav-server-rs = {
      enable = true;
      settings = {
        server.listen = ["127.0.0.1:8080" "[::1]:8080"];
        # server.tls_listen = ["0.0.0.0:443"];

        accounts = {
          auth-type = "htpasswd.default";
          acct-type = "unix";
        };
        unix = {
          supplementary-groups = true;
        };
        htpasswd.default = {
          # The password was generated using:
          # `nix shell nixpkgs#apacheHttpd`, then `htpasswd -B -c ./htpasswd default`
          # where "default" is the username
          # The username in the htpasswd corresponds to the username for the account on the server
          # , which is "olai" in this case
          htpasswd = config.sops.secrets."webdav/password".path;
        };
        location = [
          {
            route = ["/*path"];
            # This directory has to be manually created before connecting
            directory = "~/webdav";
            handler = "filesystem";
            methods = ["webdav-rw"];
            autoindex = true;
            auth = "true";
            setuid = true;
          }
        ];
      };
    };
  };
}
