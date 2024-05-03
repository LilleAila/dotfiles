{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.steam.enable = lib.mkEnableOption "steam";
  options.settings.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkMerge [
    (lib.mkIf config.settings.steam.enable {
      programs.steam = {
        enable = true;
        package = pkgs.steam;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        # gamescopeSession.enable = true;
      };

      settings.nix.unfree = [
        "steam"
        "steam-original"
        "steam-run"
      ];

      settings.gaming.enable = true;
    })
    (lib.mkIf config.settings.gaming.enable {
      programs.gamemode.enable = true;
      programs.gamescope.enable = true;
      # environment.systemPackages = with pkgs; [mangohud];
    })
  ];
}
