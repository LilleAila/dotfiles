{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.settings.gaming.enable = lib.mkEnableOption "gaming";
  options.settings.gaming.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf config.settings.gaming.enable {
    # Other stuff like steam is enabled in system module gaming.nix
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    home.packages = with pkgs; [
      heroic
      ryujinx
      prismlauncher
    ];

    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        # So that the titlebar doean't show up outside the window and mess with the rendering
        "fakefullscreen, title:(Minecraft*)"
      ];
    };
  };
}
