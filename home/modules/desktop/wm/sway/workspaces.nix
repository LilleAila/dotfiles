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
        workspace = "1";
        output = "eDP-1";
      }
      {
        workspace = "2";
        output = "eDP-1";
      }
      {
        workspace = "3";
        output = "eDP-1";
      }
      {
        workspace = "4";
        output = "eDP-1";
      }
      {
        workspace = "5";
        output = "eDP-1";
      }
      {
        workspace = "6";
        output = "HDMI-A-1";
      }
      {
        workspace = "7";
        output = "HDMI-A-1";
      }
      {
        workspace = "8";
        output = "HDMI-A-1";
      }
      {
        workspace = "9";
        output = "HDMI-A-1";
      }
      {
        workspace = "10";
        output = "HDMI-A-1";
      }
    ];

  };
}
