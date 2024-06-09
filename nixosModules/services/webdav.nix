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

    networking.firewall.allowedTCPPorts = [8080];
    networking.firewall.allowedUDPPorts = [8080];

    services.webdav-server-rs = {
      enable = true;
      settings = {
        server.listen = ["0.0.0.0:8080" "[::1]:8080"];
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
