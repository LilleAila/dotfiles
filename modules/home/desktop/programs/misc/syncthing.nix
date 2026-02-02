{ lib, ... }:
{
  flake.modules.homeManager.syncthing =
    {
      config,
      pkgs,
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

          overrideDevices = false; # Causes issues where some of the devices just do not get added for some reason

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
              m4air-darwin = {
                id = secrets.ids.m4air-darwin;
              };
              "Pixel 8a" = {
                id = secrets.ids.pixel8a;
              };
              oppad3 = {
                id = secrets.ids.oppad3;
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
                  "m4air-darwin"
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
                  "m4air-darwin"
                ];
              };
              "Notes" = {
                path = "${config.home.homeDirectory}/notes";
                devices = [
                  "oci"
                  "e14g5"
                  "desktop"
                  "m4air-darwin"
                  "t420"
                  # NOTE: android is configured imperatively. `path` defined above does *not* apply
                  "Pixel 8a"
                  "oppad3"
                ];
              };
              "Android Camera" = {
                id = "pixel_8a_nd5h-photos";
                path = "${config.home.homeDirectory}/Pictures/Android/DCIM";
                devices = [
                  "oci"
                  "e14g5"
                  "desktop"
                  "m4air-darwin"
                  "t420"
                  "Pixel 8a"
                ];
              };
              "Android Screenshots" = {
                id = "fqpt7-c6be0";
                path = "${config.home.homeDirectory}/Pictures/Android/Screenshots";
                devices = [
                  "oci"
                  "e14g5"
                  "desktop"
                  "m4air-darwin"
                  "t420"
                  "Pixel 8a"
                ];
              };
              "Calibre Library" = {
                path = "${config.home.homeDirectory}/Calibre\ Library";
                devices = [
                  "oci"
                  "e14g5"
                  "desktop"
                  "m4air-darwin"
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
                  "m4air-darwin"
                ];
              };
              "Minecraft" = {
                path = "${config.home.homeDirectory}/.local/share/PrismLauncher/instances";
                devices = [
                  "oci"
                  "e14g5"
                  "desktop"
                  "m4air-darwin"
                ];
              };
            };
          };
        };
      };
    };
}
