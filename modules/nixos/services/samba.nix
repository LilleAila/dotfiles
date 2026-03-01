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

            # NOTE: mount on client with:
            # sudo mount.cifs //192.168.68.120/jellyfin /mnt/jellyfin -o username=olai,uid=$(id -u),gid=$(id -g),sec=ntlmssp
            # (requires nixpkgs#cifs-utils)
            jellyfin = {
              path = "/srv/jellyfin";
              browseable = "yes";
              "read only" = "no";
              "guest ok" = "no";
              # NOTE: set password with sudo smbpasswd -a username
              "valid users" = user; # login user
              "force user" = "jellyfin"; # filesystem user
              "force group" = "jellyfin";
              "create mask" = "0644";
              "directory mask" = "0755";
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
