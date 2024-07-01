{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  options.settings.xdg.enable = lib.mKEnableOption "XDG stuff";

  config = lib.mkIf config.settings.xdg.enable {
    # xdg.portal = {
    #   enable = true;
    #   xdgOpenUsePortal = true;
    # };

    # TODO: set up mime apps properly (template from KDE)
  };
}
