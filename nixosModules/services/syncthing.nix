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

  config = lib.mkIf config.settings.syncthing.enable {
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
        };
        folders = {
          "Default Folder" = {
            path = "${homePath}/Sync";
            devices = ["legion"];
          };
          "Factorio" = {
            path = "${homePath}/factorio";
            devices = ["legion"];
            ignorePerms = false;
          };
        };
      };
    };
  };
}
