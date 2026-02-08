{ self, lib, ... }:
{
  flake.modules.darwin.jankyborders =
    { config, ... }:
    {
      options.settings.jankyborders.enable = lib.mkEnableOption "jankyborders";

      config = lib.mkIf config.settings.jankyborders.enable {
        launchd.user.agents.jankyborders.serviceConfig.Nice = -20;

        services.jankyborders = with self.colorScheme.palette; {
          enable = true;
          active_color = "0xFF${base06}";
          inactive_color = "0xFF${base01}";
          background_color = "0x00000000";
          blur_radius = 0.0;
          order = "above";
          style = "round";
          width = 1.0;
        };
      };
    };
}
