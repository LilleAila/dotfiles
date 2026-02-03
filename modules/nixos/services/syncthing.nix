/*
  https://nixos.wiki/wiki/Syncthing
  https://wes.today/nixos-syncthing
*/
{ self, lib, ... }:
{
  flake.modules.nixos.syncthing =
    {
      pkgs,
      config,
      user,
      ...
    }:
    let
      inherit (config.hm.home) homeDirectory;
      secrets = self.secrets.syncthing;
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
            inherit user;
            dataDir = homeDirectory;
            configDir = "${homeDirectory}/.config/syncthing";
            openDefaultPorts = true;
            overrideDevices = false; # Fails to add device? https://github.com/NixOS/nixpkgs/issues/326704 https://github.com/NixOS/nixpkgs/issues/394405
            overrideFolders = true;
            # inherit (config.hm.services.syncthing) settings;
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
                  path = "${homeDirectory}/Sync";
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
                  path = "${homeDirectory}/.spell";
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
                  path = "${homeDirectory}/notes";
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
                  path = "${homeDirectory}/Pictures/Android/DCIM";
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
                  path = "${homeDirectory}/Pictures/Android/Screenshots";
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
                  path = "${homeDirectory}/Calibre\ Library";
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
                  path = "${homeDirectory}/.factorio";
                  devices = [
                    "oci"
                    "e14g5"
                    "desktop"
                    "m4air-darwin"
                  ];
                };
                "Minecraft" = {
                  path = "${homeDirectory}/.local/share/PrismLauncher/instances";
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
        })
      ];
    };
}
