{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.mkIf config.hm.settings.gaming.steam.enable {
      programs.steam = {
        enable = true;
        package = pkgs.steam;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      settings.nix.unfree = [
        "steam"
        "steam-original"
        "steam-run"
      ];
    })
    (lib.mkIf config.hm.settings.gaming.enable {
      programs.gamemode.enable = true;
      programs.gamescope.enable = true;
    })
  ];
}
