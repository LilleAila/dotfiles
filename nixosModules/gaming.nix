{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
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

      settings.persist.home.cache = [
        ".local/share/Steam"
        ".local/share/applications" # Steam puts the apps here
      ];
    })
    (lib.mkIf config.hm.settings.gaming.enable {
      programs.gamemode.enable = true;
      programs.gamescope.enable = true;
      # Use system glfw libraries in prismlauncher, from the workarounds tab
      # For some reason, i get extremely bad performance running through xwayland
      hardware.opengl.extraPackages = with pkgs; [ glfw-wayland-minecraft ];
      environment.sessionVariables = {
        # Make factorio use the correct video driver (see FFF#408)
        "SDL_VIDEODRIVER" = "wayland";
      };
    })
  ];
}
