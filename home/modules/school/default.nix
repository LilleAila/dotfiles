{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options.settings.school.enable = lib.mkEnableOption "school apps";

  config = lib.mkIf config.settings.school.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          teams-for-linux
          anki-bin
          geogebra6
          p3x-onenote
        ];

        programs.translate-shell = {
          enable = true;
          settings = {
            hl = "en";
            tl = [
              "fr"
              "no"
            ];
            verbose = true;
          };
        };

        settings.persist.home.directories = [
          ".local/share/Anki2"
          ".config/teams-for-linux"
          ".config/libreoffice"
        ];

        settings.persist.home.cache = [ ".config/GeoGebra" ];
      }
      {
        home.packages = with pkgs; [
          (inputs.wrapper-manager.lib.build {
            inherit pkgs;
            modules = [
              {
                wrappers.libreoffice = {
                  basePackage = libreoffice;
                  extraPackages = [
                    temurin-jre-bin-17
                    (hunspellWithDicts (
                      with hunspellDicts;
                      [
                        nb-no
                        nn-no
                        en-us-large
                        en-gb-large
                        fr-any
                      ]
                    ))
                  ];
                };
              }
            ];
          })
          zotero
          poppler_utils
        ];

        # https://wiki.nixos.org/wiki/Zotero
        # the wiki is badly written, using tmpfiles is better
        systemd.user.tmpfiles.rules =
          lib.lists.flatten (
            lib.attrsets.mapAttrsToList (profile: _: [
              "L+ ${config.home.homeDirectory}/.mozilla/firefox/${profile}/zotero/pdftotext-Linux-x86_64 - - - - ${lib.getExe' pkgs.poppler_utils "pdftotext"}"
              "L+ ${config.home.homeDirectory}/.mozilla/firefox/${profile}/zotero/pdfinfo-Linux-x86_64 - - - - ${lib.getExe' pkgs.poppler_utils "pdfinfo"}"
            ]) config.programs.firefox.profiles
          )
          ++ [
            "L+ ${config.home.homeDirectory}/Documents/Zotero_LibreOffice_Integration.oxt - - - - ${pkgs.zotero}/usr/lib/zotero-bin-7.0/integration/libreoffice/Zotero_LibreOffice_Integration.oxt"
          ];

        settings.persist.home.directories = [
          "Zotero"
          ".zotero"
        ];

        wayland.windowManager.sway.config.window.commands = [
          {
            criteria.app_id = "Zotero";
            # criteria.title = "(Framgang|Progress|Hurtigformater henvisning|Quick Format Citation)";
            command = "floating enable";
          }
          # {
          #   criteria.app_id = "Zotero";
          #   criteria.title = ".* - Zotero";
          #   command = "move scratchpad";
          # }
        ];
      }
    ]
  );
}
