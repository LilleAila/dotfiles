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
        settings = {
          options = {
            # TODO: maybe set up my own relay, but i can't find any nix options for custom relays
            urAccepted = -1; # Don't submit usage data
            relaysEnabled = true;
          };
          gui = {
            user = "${username}";
            password = "${secrets.password}";
          };
          devices = {
            t420 = {
              id = "${secrets.ids.t420}";
            };
            oci = {
              id = "${secrets.ids.oci}";
            };
            e14g5 = {
              id = "${secrets.ids.e14g5}";
            };
            x220 = {
              id = "${secrets.ids.x220}";
            };
            desktop = {
              id = "${secrets.ids.desktop}";
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
              ];
            };
            "Obsidian Notes" = {
              path = "${homePath}/notes/obsidian";
              devices = [
                "oci"
                "e14g5"
                "desktop"
              ];
            };
            # TODO: steam sync is probably good now, so switch back to steam-managed factorio
            "Factorio Saves" = {
              path = "${homePath}/.factorio";
              devices = [
                "oci"
                "e14g5"
                "desktop"
              ];
            };
            "Minecraft" = {
              path = "${homePath}/.local/share/PrismLauncher/instances";
              devices = [
                "oci"
                "e14g5"
                "desktop"
              ];
            };
          };
        };
      };
    })
  ];
}
