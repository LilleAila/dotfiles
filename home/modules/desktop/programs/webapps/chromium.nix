{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.settings.webapps.chromium = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, name, ... }:
        {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              default = name;
            };
            genericName = lib.mkOption {
              type = lib.types.str;
              default = config.name;
            };
            url = lib.mkOption { type = lib.types.str; };
            icon = lib.mkOption { type = lib.types.str; };
          };
        }
      )
    );
    default = { };
  };

  config = {
    settings.persist.home.cache = [ ".cache/chromium" ];

    xdg.desktopEntries = lib.attrsets.mapAttrs' (
      name: cfg:
      lib.attrsets.nameValuePair "hm-webapp-chromium-${name}" {
        inherit (cfg) name icon genericName;
        exec = lib.strings.concatStringsSep " " [
          "${lib.getExe pkgs.ungoogled-chromium}"
          "--user-data-dir=\"${config.home.homeDirectory}/.config/chromium/${name}\""
          "--app=${cfg.url}"
        ];
        terminal = false;
        type = "Application";
      }
    ) config.settings.webapps.chromium;

    settings.persist.home.directories = lib.attrsets.mapAttrsToList (
      name: cfg: ".config/chromium/${name}"
    ) config.settings.webapps.chromium;
  };
}
