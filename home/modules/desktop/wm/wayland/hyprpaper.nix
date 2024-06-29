{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings = {
    wm.hyprpaper.enable = lib.mkEnableOption "hyprpaper";
    wm.hyprpaper.wallpaper = lib.mkOption' lib.types.path null;
  };

  # imports = [
  #   inputs.hyprpaper.homeManagerModules.hyprpaper
  # ];

  config = lib.mkIf (config.settings.wm.hyprpaper.enable) {
    services.hyprpaper = {
      package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
      enable = true;
      settings = {
        splash = true;
        ipc = true;

        preload = [(toString config.settings.wm.hyprpaper.wallpaper)];
        wallpaper = [", ${toString config.settings.wm.hyprpaper.wallpaper}"];
        # preload = map (m: "${toString m.wallpaper}") (config.settings.monitors);
        # wallpaper = map (m: "${toString m.name}, ${toString m.wallpaper}") (config.settings.monitors);
      };
    };
  };
}
