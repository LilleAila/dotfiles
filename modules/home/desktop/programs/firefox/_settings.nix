{ config, ... }:
{
  # First run
  "app.normandy.first_run" = false;
  "doh-rollout.doneFirstRun" = true;
  "toolkit.telemetry.reportingpolicy.firstRun" = false;

  # Privacy
  "dom.security.https_only_mode" = true;
  "identity.fxaccounts.enabled" = false;
  "signon.rememberSignons" = false;
  "privacy.trackingprotection.enabled" = true;
  "privacy.donottrackheader.enabled" = true;
  "privacy.fingerprintingProtection.enabled" = true;
  "privacy.globalprivacycontrol.enabled" = true;

  # New tab page
  "browser.startup.homepage" = "http://localhost:6969"; # searx
  "browser.startup.page" = 3; # `1` default, `3` restore pages
  "browser.newtabpage.activity-stream.showSearch" = false;
  "browser.newtabpage.activity-stream.feeds.topsites" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

  # UI and URL bar
  "browser.urlbar.shortcuts.bookmarks" = false;
  "browser.urlbar.shortcuts.history" = false;
  "browser.urlbar.shortcuts.tabs" = false;
  "browser.urlbar.suggest.engines" = false;
  "browser.urlbar.suggest.openpage" = false;
  "browser.urlbar.suggest.topsites" = false;
  "browser.tabs.firefox-view" = false;
  "browser.tabs.tabmanager.enabled" = false;
  "browser.disableResetPrompt" = true;
  "browser.download.panel.shown" = true;
  "browser.download.useDownloadDir" = false;
  "browser.toolbars.bookmarks.visibility" = "never"; # newtab/never/always
  "widget.gtk.overlay-scrollbars.enabled" = false;

  # Translations
  "browser.translations.panelShown" = true;
  "browser.translations.enable" = false;
  "browser.translations.automaticallyPopup" = false;
  "browser.translations.neverTranslateLanguages" = "nb,nn,fr,en";

  # Telemetry and stuff
  "app.shield.optoutstudies.enabled" = false;
  "toolkit.telemetry.pioneer-new-studies-available" = false;
  "browser.contentblocking.report.show_mobile_app" = false;
  "extensions.pocket.enabled" = false;
  "datareporting.policy.firstRunURL" = ""; # skips "at mozilla we believe..."
  "datareporting.healthreport.uploadEnabled" = false;
  "datareporting.policy.dataSubmissionEnabled" = false; # https://bugzilla.mozilla.org/show_bug.cgi?id=1195552#c4
  "browser.shell.checkDefaultBrowser" = false;
  "browser.shell.defaultBrowserCheckCount" = 1;
  "browser.startup.homepage_override.mstone" = "ignore";

  # DRM
  "browser.eme.ui.enabled" = true;
  "media.eme.enabled" = true;

  # Other stuff
  "media.hardware-video-decoding.force-enabled" = true;
  "layers.acceleration.force-enabled" = true;

  "general.autoScroll" = false;
  "browser.aboutConfig.showWarning" = false;
  "extensions.autoDisableScopes" = 0; # enables all extensions
  "media.videocontrols.picture-in-picture.enabled" = false;
  "mousewheel.with_control.action" = 0; # Disable ctrl+scroll to zoom

  "devtools.debugger.remote-enabled" = true;
  "devtools.chrome.enabled" = true; # ctrl+alt+shift+i to open browser toolbox
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

  "browser.tabs.inTitlebar" = 0;
  "privacy.exposeContentTitleInWindow" = false;
  "privacy.exposeContentTitleInWindow.pbm" = false;

  # Fonts
  "font.name.monospace.x-western" = config.settings.fonts.monospace.name;
  "font.name.sans-serif.x-western" = config.settings.fonts.sansSerif.name;
  "font.name.serif.x-western" = config.settings.fonts.serif.name;

  # UI Customization, themes and stuff
  "ui.systemUsesDarkTheme" = 1;
  # "browser.theme.native-theme" = false; # do not use the GTK theme
  # To change this, just modify the toolbar with the editor inside firefox and copy the new value here.
  "browser.uiCustomization.state" = builtins.toJSON {
    "placements" = {
      "widget-overflow-fixed-list" = [ ];
      "unified-extensions-area" = [
        "sponsorblocker_ajay_app-browser-action"
        "ublock0_raymondhill_net-browser-action"
        "addon_darkreader_org-browser-action"
        "zotero_chnm_gmu_edu-browser-action"
      ];
      "nav-bar" = [
        "back-button"
        "forward-button"
        "alltabs-button"
        "urlbar-container"
        "downloads-button"
        "unified-extensions-button"
        "vertical-spacer"
        "reset-pbm-toolbar-button"
      ];
      "toolbar-menubar" = [ "menubar-items" ];
      "TabsToolbar" = [
        "tabbrowser-tabs"
        "new-tab-button"
      ];
      "vertical-tabs" = [ ];
      "PersonalToolbar" = [ "personal-bookmarks" ];
    };
    "seen" = [
      "addon_darkreader_org-browser-action"
      "ublock0_raymondhill_net-browser-action"
      "_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action"
      "_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action"
      "_9a41dee2-b924-4161-a971-7fb35c053a4a_-browser-action"
      "sponsorblocker_ajay_app-browser-action"
      "zotero_chnm_gmu_edu-browser-action"
      "_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action"
      "developer-button"
      "screenshot-button"
    ];
    "dirtyAreaCache" = [
      "unified-extensions-area"
      "nav-bar"
      "toolbar-menubar"
      "TabsToolbar"
      "vertical-tabs"
      "PersonalToolbar"
      "widget-overflow-fixed-list"
    ];
    "currentVersion" = 23;
    "newElementCount" = 16;
  };
}
