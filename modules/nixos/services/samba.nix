{ lib, ... }:
{
  flake.modules.nixos.samba =
    { config, user, ... }:
    let
      cfg = config.settings.samba;
    in
    {
      options.settings.samba.enable = lib.mkEnableOption "samba";

      config = lib.mkIf cfg.enable {
        services.samba = {
          enable = true;
          openFirewall = true;
          winbindd.enable = false;

          settings = {
            global = {
              workgroup = "WORKGROUP";
              "server string" = "smbnix";
              security = "user";
              "guest account" = "nobody";
              "map to guest" = "bad user";
            };

            jellyfin = {
              path = "/srv/jellyfin";
              browseable = "yes";
              "read only" = "no";
              "guest ok" = "no";
              "create mask" = "0644";
              "directory mask" = "0755";
              # NOTE: set password with sudo smbpasswd -a username
              "valid users" = user;
              "force user" = user;
            };
          };
        };

        users.users.${user}.extraGroups = [ "samba" ];

        settings.persist.root.directories = [
          "/var/lib/samba"
          "/var/log/samba"
        ];

        systemd.tmpfiles.rules = [
          "d /var/lib/samba 0755 root root -"
          "d /var/lib/samba/private 0700 root root -"
        ];
      };
    };
}
