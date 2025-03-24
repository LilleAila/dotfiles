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
        "nikitabobko/tap"
        "LilleAila/tap"
      ];
      casks = [
        "ghostty"
        "vesktop" # packaged myself, see https://github.com/Vencord/Vesktop/issues/172
        "aerospace"
        # "microsoft-auto-update" # maybe needed, maybe not; idk
        # "microsoft-office"
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
        "sioyek"
        "obsidian"
        "jupyterlab"
        "chatgpt"
        "vesktop"
        "soapui"
        "prismlauncher"
        "ukelele"
        "kicad"
        "scroll-reverser"
        "tor-browser"
        "dymo-connect"
        "raspberry-pi-imager"
        "eloston-chromium" # ungoogled-chromium
        "openscad"
        # Not apple silicon; requires rosetta 2
        "ordnett-pluss"
        "steam"
      ];
      # Requires apps to be already "purchased" (press get)
      # sometimes works, sometimes doesn't /shrug
      # running `mas purchase` will fix this, making it so subsequent installations of the same app will work
      masApps = {
        "1Password for Safari" = 1569813296;
        # "Lichess" = 968371784; # https://github.com/mas-cli/mas/issues/321
        # Installing from app store avoids using microsoft auto update
        # Teams is not present, but is also provided as a separate package, which does not use MAU
        "Microsoft Word" = 462054704;
        "Microsoft Outlook" = 985367838;
        "Microsoft Excel" = 462058435;
        "Microsoft PowerPoint" = 462062816;
        "Microsoft OneNote" = 784801555;
      };
    };
  };
}
