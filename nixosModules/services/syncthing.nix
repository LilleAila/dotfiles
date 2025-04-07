/*
  https://nixos.wiki/wiki/Syncthing
  https://wes.today/nixos-syncthing
*/
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  username = config.settings.user.name;
  homePath = "/home/${username}";
  secrets = import ../../secrets/syncthing.nix;
in
{
  options.settings.syncthing.enable = lib.mkEnableOption "Syncthing";

  config = lib.mkMerge [
    (lib.mkIf config.settings.syncthing.enable {
      settings.persist.home.directories = [
        "Documents/Obsidian Vault"
        "org"

        "Sync"
        ".factorio"
        ".local/share/PrismLauncher/instances"
        ".spell"
      ];

      settings.persist.home.cache = [ ".config/syncthing" ];

      # Config panel at http://127.0.0.1:8384/
      # Go to the config panel to find the device ID
      services.syncthing = {
        enable = true;
        user = username;
        dataDir = "/home/${username}";
        configDir = "/home/${username}/.config/syncthing";
        openDefaultPorts = true;
        overrideDevices = true;
        overrideFolders = true;
        # inherit (config.hm.services.syncthing) settings;
        settings = {
          options = {
            urAccepted = -1; # Don't submit usage data
            relaysEnabled = true;
          };

          gui = {
            user = username;
            inherit (secrets) password;
          };

          devices = {
            t420 = {
              id = secrets.ids.t420;
            };
            oci = {
              id = secrets.ids.oci;
            };
            e14g5 = {
              id = secrets.ids.e14g5;
            };
            x220 = {
              id = secrets.ids.x220;
            };
            desktop = {
              id = secrets.ids.desktop;
            };
            m1pro = {
              id = secrets.ids.m1pro;
            };
            m1pro-darwin = {
              id = secrets.ids.m1pro-darwin;
            };
            "Pixel 8a" = {
              id = secrets.ids.pixel8a;
            };
          };

          folders = {
            "Default Folder" = {
              path = "${homePath}/Sync";
              devices = [
                "oci"
                "t420"
                "e14g5"
                "x220"
                "desktop"
                "m1pro"
                "m1pro-darwin"
              ];
            };
            "Spell" = {
              path = "${homePath}/.spell";
              devices = [
                "oci"
                "t420"
                "e14g5"
                "x220"
                "desktop"
                "m1pro"
                "m1pro-darwin"
              ];
            };
            "Notes" = {
              path = "${homePath}/notes";
              devices = [
                "oci"
                "e14g5"
                "desktop"
                "m1pro"
                "m1pro-darwin"
                "t420"
                "Pixel 8a" # NOTE: android is configured imperatively. `path` defined above does *not* apply
              ];
            };
            "Android Camera" = {
              id = "pixel_8a_nd5h-photos";
              path = "${homePath}/Pictures/Android";
              devices = [
                "oci"
                "e14g5"
                "desktop"
                "m1pro"
                "m1pro-darwin"
                "t420"
                "Pixel 8a"
              ];
            };
            "Calibre Library" = {
              path = "${homePath}/Calibre\ Library";
              devices = [
                "oci"
                "e14g5"
                "desktop"
                "m1pro"
                "m1pro-darwin"
                "t420"
              ];
            };
            # TODO: steam sync is probably good now, so switch back to steam-managed factorio
            "Factorio Saves" = {
              path = "${homePath}/.factorio";
              devices = [
                "oci"
                "e14g5"
                "desktop"
                "m1pro-darwin"
              ];
            };
            "Minecraft" = {
              path = "${homePath}/.local/share/PrismLauncher/instances";
              devices = [
                "oci"
                "e14g5"
                "desktop"
                "m1pro-darwin"
              ];
            };
          };
        };
      };
    })
  ];
}
