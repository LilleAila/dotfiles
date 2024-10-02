{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options.settings.school.enable = lib.mkEnableOption "school apps";

  config = lib.mkIf config.settings.school.enable {
    home.packages = with pkgs; [
      teams-for-linux
      libreoffice
      # jre_minimal
      temurin-jre-bin-17
      anki-bin
      zotero
    ];

    settings.persist.home.directories = [
      ".local/share/Anki2"
      ".config/teams-for-linux"
      ".config/libreoffice"
      "Zotero"
      ".zotero"
    ];
  };
}
