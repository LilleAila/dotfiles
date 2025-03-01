{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:
{
  options.settings.system.enable = lib.mkEnableOption "system config";

  config = lib.mkIf config.settings.system.enable {
    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 6;

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
      defaults = {
        CustomUserPreferences = {
          NSGlobalDomain = {
            WebAutomaticSpellingCorrectionEnabled = false;
          };
        };

        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.0;
          tilesize = 38;
          largesize = 64;
          magnification = true;
          mru-spaces = false;
          orientation = "left";
          show-process-indicators = true;
          show-recents = false;
          expose-group-apps = true; # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
        };

        spaces = {
          # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces
          spans-displays = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          CreateDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowExternalHardDrivesOnDesktop = false;
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv"; # List view
          ShowPathbar = true;
        };

        controlcenter = {
          # Menu bar.
          AirDrop = false;
          BatteryShowPercentage = true;
          Bluetooth = false;
          Display = false;
          FocusModes = false;
          NowPlaying = false;
          Sound = false;
        };

        screencapture = {
          show-thumbnail = false;
          target = "clipboard";
        };

        menuExtraClock = {
          IsAnalog = false;
          ShowDate = 1;
          ShowDayOfMonth = true;
          ShowDayOfWeek = true;
          ShowSeconds = true;
        };

        NSGlobalDomain = {
          # AppleFontSmoothing = 0;
          AppleInterfaceStyle = "Dark";
          # AppleKeyboardUIMode = 3; # https://support.apple.com/guide/mac-help/navigate-your-mac-using-full-keyboard-access-mchlc06d1059/mac
          # ApplePressAndHoldEnabled = false;
          AppleShowAllExtensions = false; # file extensions
          AppleShowAllFiles = true;
          InitialKeyRepeat = 10;
          KeyRepeat = 1;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticInlinePredictionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          # NSDocumentSaveNewDocumentsToCloud = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSUseAnimatedFocusRing = false;
          NSWindowShouldDragOnGesture = true; # Move window with ctrl + cmd + drag
          # _HIHideMenuBar = true;
          # "com.apple.keyboard.fnState" = true; # F-keys as f-keys by default
          # "com.apple.swipescrolldirection" = true; # use the objectively correct tracpkad scrolling direction (already default)
          # "com.apple.trackpad.forceClick" = true; (default)
        };

        WindowManager = {
          EnableStandardClickToShowDesktop = false;
        };
      };
    };
  };
}
