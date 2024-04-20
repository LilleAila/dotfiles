{config, ...}: {
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
  "browser.startup.homepage" = "https://start.duckduckgo.com";
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
  "browser.translations.enable" = true;
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

  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

  # Fonts
  "font.name.monospace.x-western" = config.settings.fonts.monospace.name;
  "font.name.sans-serif.x-western" = config.settings.fonts.sansSerif.name;
  "font.name.serif.x-western" = config.settings.fonts.serif.name;
}
