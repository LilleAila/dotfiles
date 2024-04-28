{
  pkgs,
  lib,
  config,
  ...
}: {
  options.settings.webapps.firefox = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({
      config,
      name,
      ...
    }: {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
        };
        genericName = lib.mkOption {
          type = lib.types.str;
          default = config.name;
        };
        url = lib.mkOption {
          type = lib.types.str;
        };
        icon = lib.mkOption {
          type = lib.types.str;
        };
        id = lib.mkOption {
          type = lib.types.int;
          description = "The id of the firefox profile.";
        };
        extraUserChrome = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
        extraSettings = lib.mkOption {
          type = lib.types.attrsOf (lib.types.either lib.types.bool (lib.types.either lib.types.int lib.types.str));
          default = {};
        };
      };
    }));
    default = {};
  };

  config = {
    programs.firefox.profiles =
      lib.attrsets.mapAttrs'
      (name: cfg:
        lib.attrsets.nameValuePair "hm-webapp-firefox-${name}" {
          inherit (cfg) id;
          userChrome =
            ''
              @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

              browser {
                margin-right: 0px; margin-bottom: 0px;
              }

              #TabsToolbar {
                visibility: collapse !important;
              }

              #nav-bar {
                margin-top: 0;
                margin-bottom: -42px;
                z-index: -100;
              }

              #main-window[windowtype="navigator:browser"] {
                background-color: transparent !important;
              }

              .tab-background[selected="true"] {
                background: ${config.colorScheme.palette.base00} !important;
              }

              #navigator-toolbox {
                display: none !important;
              }
            ''
            + cfg.extraUserChrome;

          settings =
            cfg.extraSettings
            // {
              "browser.sessionstore.resume_session_once" = false;
              "browser.sessionstore.resume_from_crash" = false;
              "browser.cache.disk.enable" = false;
              "browser.cache.disk.capacity" = 0;
              "browser.cache.disk.filesystem_reported" = 1;
              "browser.cache.disk.smart_size.enabled" = false;
              "browser.cache.disk.smart_size.first_run" = false;
              "browser.cache.disk.smart_size.use_old_max" = false;
              "browser.ctrlTab.previews" = true;
              "browser.tabs.warnOnClose" = false;
              "plugin.state.flash" = 2;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "browser.tabs.drawInTitlebar" = false;
              "browser.tabs.inTitlebar" = 0;
              "browser.contentblocking.category" = "strict";
              "network.cookie.lifetimePolicy" = 0;
              "layout.css.prefers-color-scheme.content-override" = 0;
            };
        })
      (config.settings.webapps.firefox);
    xdg.desktopEntries =
      lib.attrsets.mapAttrs'
      (name: cfg:
        lib.attrsets.nameValuePair "hm-webapp-firefox-${name}" {
          inherit (cfg) name icon genericName;
          exec = lib.strings.concatStringsSep " " [
            "${lib.getExe config.programs.firefox.package}"
            "-P"
            "${config.programs.firefox.profiles."hm-webapp-firefox-${name}".path}"
            "--no-remote"
            "${cfg.url}"
          ];
          terminal = false;
          type = "Application";
        })
      (config.settings.webapps.firefox);
  };
}
