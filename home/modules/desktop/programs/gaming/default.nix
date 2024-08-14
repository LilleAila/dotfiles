{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.settings.gaming.enable = lib.mkEnableOption "gaming";
  options.settings.gaming.steam.enable = lib.mkEnableOption "steam";

  imports = [ ./prismlauncher.nix ];

  config = lib.mkIf config.settings.gaming.enable {
    # Other stuff like steam is enabled in system module gaming.nix
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    settings.nix.unfree = [
      "factorio-alpha"
      "factorio-headless"
      "factorio-demo"
      "osu-lazer-bin"
    ];

    settings.persist.home.cache = [ ".config/heroic" ];

    home.packages = with pkgs; [
      # heroic # FIXME: currently broken :(
      ryujinx
      (pkgs.factorio.override {
        # It's easier to use the built-in mod manager than to package it with nix
        inherit (import ../../../../../secrets/factorio.nix) username token;
        versionsJson = inputs.factorio-versions.versions;
        experimental = false;
      })
      osu-lazer-bin
    ];
  };
}
