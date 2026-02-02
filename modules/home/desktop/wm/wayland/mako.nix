{ self, lib, ... }:
{
  flake.modules.homeManager.mako =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings.wm.mako.enable = lib.mkEnableOption "mako";

      config = lib.mkIf config.settings.wm.mako.enable {
        services.mako = {
          enable = true;
          backgroundColor = "#${self.colorScheme.palette.base01}";
          borderColor = "#${self.colorScheme.palette.base0E}";
          borderRadius = 5;
          borderSize = 2;
          textColor = "#${self.colorScheme.palette.base04}";
          layer = "overlay";
        };
      };
    };
}
