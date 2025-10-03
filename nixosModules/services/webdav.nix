/*
  Notes:
  https://github.com/pmeiyu/nixos-config/blob/master/modules/webdav.nix
  https://github.com/miquels/webdav-server-rs/blob/master/webdav-server.toml
  https://nixos.wiki/wiki/Nginx (section about TLS reverse proxy)
  For cloudflare, remember to disable proxy in the A record!!!!!!!
*/
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.settings.webdav.enable = lib.mkEnableOption "webdav";

  config = lib.mkIf config.settings.webdav.enable {
    sops.secrets."tunnels/webdav" = {
      owner = "cloudflared";
      group = "cloudflared";
    };

    # services.cloudflared.tunnels.${(import ../../secrets/tokens.nix).webdav.id} = {
    #   credentialsFile = config.sops.secrets."tunnels/webdav".path;
    #   default = "http_status:404";
    #   ingress = {
    #     "webdav.olai.dev" = "http://localhost:8080";
    #   };
    # };

    services.caddy.virtualHosts."webdav.olai.dev" = ''
      reverse_proxy http://127.0.0.1:8080
    '';

    sops.secrets."webdav/password" = {
      owner = "webdav";
      group = "webdav";
    };

    services.webdav-server-rs = {
      enable = true;
      settings = {
        server.listen = [ "127.0.0.1:8080" ];

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
            route = [ "/*path" ];
            # This directory has to be manually created before connecting
            directory = "~/webdav";
            handler = "filesystem";
            methods = [ "webdav-rw" ];
            autoindex = true;
            auth = "true";
            setuid = true;
          }
        ];
      };
    };
  };
}
