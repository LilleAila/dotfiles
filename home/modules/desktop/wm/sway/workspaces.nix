{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkIf config.settings.wm.sway.enable {
  wayland.windowManager.sway.config = {
    workspaceAutoBackAndForth = false;
    defaultWorkspace = "workspace 1";
    workspaceOutputAssign = [
      {
        workspace = "number 1";
        output = "eDP-1";
      }
      {
        workspace = "number 2";
        output = "eDP-1";
      }
      {
        workspace = "number 3";
        output = "eDP-1";
      }
      {
        workspace = "number 4";
        output = "eDP-1";
      }
      {
        workspace = "number 5";
        output = "eDP-1";
      }
      {
        workspace = "number 6";
        output = "HDMI-A-1";
      }
      {
        workspace = "number 7";
        output = "HDMI-A-1";
      }
      {
        workspace = "number 8";
        output = "HDMI-A-1";
      }
      {
        workspace = "number 9";
        output = "HDMI-A-1";
      }
      {
        workspace = "number 10";
        output = "HDMI-A-1";
      }
    ];

  };
}
