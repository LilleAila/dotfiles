{ config, lib, ... }:
{
  options.settings.brew.enable = lib.mkEnableOption "brew";

  config = lib.mkIf config.settings.brew.enable {
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
      # TODO: move these things into the correct places, rather than always install.
      taps = [
        "nikitabobko/tap"
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
  };
}
