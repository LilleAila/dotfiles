{
  config,
  pkgs,
  lib,
  inputs,
  user,
  ...
}:
let
  secrets = import ../../../../../secrets/syncthing.nix;
in
{
  options.settings.syncthing.enable = lib.mkEnableOption "Syncthing";

  config = lib.mkIf config.settings.syncthing.enable {
    # Config panel at http://127.0.0.1:8384/
    services.syncthing = {
      enable = true;
      settings = {
        options = {
          urAccepted = -1; # Don't submit usage data
          relaysEnabled = true;
        };

        gui = {
          inherit user;
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
        };

        folders = {
          "Default Folder" = {
            path = "${config.home.homeDirectory}/Sync";
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
            path = "${config.home.homeDirectory}/.spell";
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
          "Obsidian Notes" = {
            path = "${config.home.homeDirectory}/notes/obsidian";
            devices = [
              "oci"
              "e14g5"
              "desktop"
              "m1pro"
              "m1pro-darwin"
              "t420"
            ];
          };
          "Calibre Library" = {
            path = "${config.home.homeDirectory}/Calibre\ Library";
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
            path = "${config.home.homeDirectory}/.factorio";
            devices = [
              "oci"
              "e14g5"
              "desktop"
              "m1pro-darwin"
            ];
          };
          "Minecraft" = {
            path = "${config.home.homeDirectory}/.local/share/PrismLauncher/instances";
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
  };
}
