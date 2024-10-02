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
        ];

        settings.persist.home.directories = [
          ".local/share/Anki2"
          ".config/teams-for-linux"
          ".config/libreoffice"
        ];
      }
      {
        home.packages = with pkgs; [
          libreoffice
          zotero
          temurin-jre-bin-17
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
            "L+ ${config.home.homeDirectory}/Documents/Zotero_LibreOffice_Integration.oxt - - - - ${pkgs.zotero}//usr/lib/zotero-bin-7.0/integration/libreoffice/Zotero_LibreOffice_Integration.oxt"
          ];

        settings.persist.home.directories = [
          "Zotero"
          ".zotero"
        ];
      }
    ]
  );
}
