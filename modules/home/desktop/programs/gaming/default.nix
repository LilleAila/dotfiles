{ lib, self, ... }:
{
  flake.modules.homeManager.gaming =
    {
      config,
      pkgs,
      ...
    }:
    {
      options.settings.gaming.enable = lib.mkEnableOption "gaming";
      options.settings.gaming.steam.enable = lib.mkEnableOption "steam";

      config = lib.mkIf config.settings.gaming.enable {
        # Other stuff like steam is enabled in system module gaming.nix
        programs.mangohud = {
          enable = false;
          enableSessionWide = false;
        };

        settings.nix.unfree = [
          "factorio-alpha"
          "factorio-headless"
          "factorio-demo"
          "factorio-space-age"
          "osu-lazer-bin"
        ];

        settings.persist.home.cache = [ ".config/heroic" ];

        settings.persist.home.directories = [
          ".config/openttd"
          ".local/share/openttd"
          ".factorio"
        ];

        home.packages = with pkgs; [
          # heroic
          # ryubing
          (pkgs.factorio.override {
            # It's easier to use the built-in mod manager than to package it with nix
            inherit (self.secrets.factorio) username token;
            releaseType = "expansion";
          })
          osu-lazer-bin
          openttd
        ];
      };
    };
}
