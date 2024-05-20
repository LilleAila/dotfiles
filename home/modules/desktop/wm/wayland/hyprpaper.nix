{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings = {
    wm.hyprpaper.enable = lib.mkEnableOption "hyprpaper";
  };

  imports = [
    inputs.hyprpaper.homeManagerModules.hyprpaper
  ];

  config = lib.mkIf (config.settings.wm.hyprpaper.enable) {
    services.hyprpaper = {
      enable = true;
      splash = true;
      ipc = true;

      preloads = map (m: "${toString m.wallpaper}") (config.settings.monitors);
      wallpapers = map (m: "${toString m.name}, ${toString m.wallpaper}") (config.settings.monitors);
    };
  };
}
