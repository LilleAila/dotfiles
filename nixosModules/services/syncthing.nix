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
    (lib.mkAssert (!config.hm.settings.syncthing.enable) (
      lib.mkIf config.settings.syncthing.enable {
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
          inherit (config.hm.services.syncthing) settings;
        };
      }
    ))
  ];
}
