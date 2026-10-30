{ lib, ... }: {
  flake.modules.nixos.openrgb =
    { config, ... }:
    let
      cfg = config.settings.openrgb;
    in
    {
      options.settings.openrgb.enable = lib.mkEnableOption "openrgb";

      config = lib.mkIf cfg.enable {
        services.hardware.openrgb = {
          enable = true;
          startupProfile = "off";
        };

        settings.persist.root.directories = [
          "/var/lib/OpenRGB"
        ];
      };
    };
}
