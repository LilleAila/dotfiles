{ config, lib, ... }:
{
  options.settings.brew.enable = lib.mkEnableOption "brew";

  config = lib.mkIf config.settings.brew.enable {
    # https://github.com/LnL7/nix-darwin/issues/786
    # (hard to uninstall)
    system.activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap"; # Uninstall all not declared
        autoUpdate = false;
        upgrade = false;
      };
      caskArgs.no_quarantine = true;
      # Unfortunately not 100% declarative :(
      # Could maybe to something like "geogebra@6.0.875.1"
      # , manually for each one
      # TODO: move these things into the correct places, rather than always install.
      taps = [
        # "nikitabobko/tap"
        "LilleAila/tap"
      ];
      brews = [
        "mas"
        "bitwarden-cli"
        "arduino-cli"
      ];
      casks = [
        "ghostty"
        "vesktop" # packaged myself, see https://github.com/Vencord/Vesktop/issues/172
        # "aerospace"
        "microsoft-teams"
        "freecad"
        "bambu-studio"
        "zotero"
        "calibre"
        "krita"
        "inkscape"
        "anki"
        "geogebra"
        "yubico-authenticator"
        "prefs-editor"
        "firefox"
        "sioyek"
        "obsidian"
        "chatgpt"
        "vesktop"
        "prismlauncher"
        "kicad"
        "scroll-reverser"
        "tor-browser"
        "dymo-connect"
        "raspberry-pi-imager"
        "ungoogled-chromium"
        "openscad@snapshot"
        "docker-desktop"
        "musescore"
        "vnc-viewer"
        "cyberduck"
        "bitwarden"
        "arduino-ide"
        "spotify"

        # music stuff
        "ableton-live-lite"
        "ilok-license-manager"
        "arturia-software-center"
        "neural-amp-modeler"
        # "uvi-workstation" # installed through uvi portal
        "uvi-portal"
        "native-access"
        "blackhole-2ch"

        # Not apple silicon; requires rosetta 2
        "steam"
      ];
      # Requires apps to be already "purchased" (press get)
      # sometimes works, sometimes doesn't /shrug
      # running `mas purchase` will fix this, making it so subsequent installations of the same app will work
      masApps = {
        # "Lichess" = 968371784; # https://github.com/mas-cli/mas/issues/321
        # Installing from app store avoids using microsoft auto update
        # Teams is not present, but is also provided as a separate package, which does not use MAU
        "Microsoft Word" = 462054704;
        "Microsoft Outlook" = 985367838;
        "Microsoft Excel" = 462058435;
        "Microsoft PowerPoint" = 462062816;
        "Microsoft OneNote" = 784801555;
        "Clarify Dictionaries" = 6451003473;
      };
    };
  };
}
