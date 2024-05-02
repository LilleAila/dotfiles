{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf config.settings.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    settings.nix.unfree = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
