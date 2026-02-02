{ lib, ... }:
{
  flake.modules.homeManager.swayidle =
    {
      inputs,
      pkgs,
      config,
      ...
    }:
    {
      options.settings.swayidle.enable = lib.mkEnableOption "swayidle";

      config = lib.mkIf config.settings.swayidle.enable {
        # TODO
      };
    };
}
