{ lib, ... }:
{
  flake.modules.nixos.sway =
    {
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      options.settings.sway.enable = lib.mkEnableOption "sway";
      config = lib.mkIf config.settings.sway.enable {
        programs.sway.enable = true;
        programs.sway.package = null;
        environment.sessionVariables = {
          SDL_VIDEODRIVER = "wayland";
          _JAVA_AWT_WM_NONREPARENTING = 1;
          QT_QPA_PLATFORM = "wayland";
          XDG_CURRENT_DESKTOP = "sway";
          XDG_SESSION_DESKTOP = "sway";
        };
      };
    };
}
