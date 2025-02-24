{
  lib,
  self,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users.olai.home = "/Users/olai";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.olai = import ./home.nix;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "hm-backup";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap"; # Uninstall all not declared
      autoUpdate = false;
      upgrade = false;
    };
    # Unfortunately not 100% declarative :(
    # Could maybe to something like "geogebra@6.0.875.1"
    # , manually for each one
    taps = [
      "nikitabobko/tap" # aerospace
    ];
    casks = [
      "ghostty"
      "discord"
      # "vesktop" # https://github.com/Vencord/Vesktop/issues/172
      "aerospace"
      "microsoft-auto-update" # maybe needed, maybe not; idk
      "microsoft-office"
      "microsoft-teams"
      "freecad"
      "bambu-studio"
      "zotero"
      "calibre"
      "krita"
      "inkscape"
      "anki"
      "geogebra"
      "1password"
      "yubico-authenticator"
      "prefs-editor"
      "firefox"
    ];
    # Requires apps to be already "purchased" (press get)
    # sometimes works, sometimes doesn't /shrug
    masApps = {
      "1Password for Safari" = 1569813296;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
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
        Bluetooth = true;
        Display = false;
        FocusModes = true;
        NowPlaying = true;
        Sound = true;
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
        AppleShowAllExtensions = true; # file extensions
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

  # Reset with updates, has to be reapplied
  security.pam.enableSudoTouchIdAuth = true;

  nix.settings.experimental-features = "nix-command flakes";
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
