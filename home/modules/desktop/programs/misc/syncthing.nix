{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings.syncthing.tray.enable = lib.mkEnableOption "Syncthing tray";

  # Not that useful, also xwayland - maybe another tray program?
  config = lib.mkIf config.settings.syncthing.tray.enable {
    systemd.user.services.syncthingtray = {
      Unit = {
        Description = "syncthingtray";
        Requires = ["tray.target"];
        After = ["graphical-session-pre.target" "tray.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${lib.getExe' pkgs.qsyncthingtray "qsyncthingtray"}";
      };

      Install = {WantedBy = ["graphical-session.target"];};
    };
  };
}
