{ self, lib, ... }:
{
  flake.modules.homeManager.swaybg =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.settings.wm.swaybg;
    in
    {
      options.settings = {
        wm.swaybg.enable = lib.mkEnableOption "swaybg";
        wm.swaybg.wallpaper = self.lib.mkOption' lib.types.path null;
      };

      config = lib.mkIf cfg.enable {
        systemd.user.services.swaybg = {
          Unit = {
            Description = "Swaybg";
            ConditionEnvironment = "WAYLAND_DISPLAY";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };

          Service = {
            Type = "simple";
            Restart = "always";
            ExecStart = "${lib.getExe pkgs.swaybg} --color ${self.colorScheme.palette.base00} --image ${cfg.wallpaper} --output * --mode fill";
          };

          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };

      };
    };
}
