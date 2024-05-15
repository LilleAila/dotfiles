/*
https://nixos.wiki/wiki/Syncthing
https://wes.today/nixos-syncthing

The folder.<name>.enable option has to be set to true for the folders to actually sync.
I think that is better to do per-system instead of globally
Also note that the devices defined here depend on my secrets private GitHub repo.
*/
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  username = config.settings.user.name;
  homePath = "/home/${username}";
  secrets = inputs.secrets.syncthing;
in {
  options.settings.syncthing.enable = lib.mkEnableOption "Syncthing";
  options.settings.syncthing.enableAllFolders = lib.mkEnableOption "Syncthing";

  config = lib.mkMerge [
    (lib.mkIf config.settings.syncthing.enableAllFolders {
      # FIXME: 1. all folders get enabled by default, so this is unnecessary
      #        2. folders are created automatically even if the computer is not listed for said folder
      services.syncthing.settings.folders = {
        "Default Folder".enable = lib.mkDefault true;
        "Factorio".enable = lib.mkDefault true;
        "Notes".enable = lib.mkDefault true;
        "Minecraft".enable = lib.mkDefault true;
      };
    })
    (lib.mkIf config.settings.syncthing.enable {
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
          gui = {
            user = "${username}";
            password = "${secrets.password}";
          };
          devices = {
            legion = {id = "${secrets.ids.legion}";};
            mac = {id = "${secrets.ids.mac}";};
            t420 = {id = "${secrets.ids.t420}";};
            oci = {id = "${secrets.ids.oci}";};
          };
          folders = {
            "Default Folder" = {
              path = "${homePath}/Sync";
              devices = ["oci" "legion" "mac" "t420"];
            };
            "Factorio" = {
              path = "${homePath}/factorio";
              devices = ["oci" "legion" "mac"];
              ignorePerms = false; # executable permissions and stuff
            };
            "Notes" = {
              path = "${homePath}/org";
              devices = ["oci" "legion" "mac" "t420"];
            };
            "Minecraft" = {
              path = "${homePath}/.local/share/PrismLauncher/instances";
              devices = ["oci" "legion" "mac"];
            };
          };
        };
      };
    })
  ];
}
