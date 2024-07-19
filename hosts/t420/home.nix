{
  config,
  pkgs,
  inputs,
  lib,
  keys,
  outputs,
  ...
}:
{
  imports = [ ../../home ];

  settings = {
    monitors = [ { name = "LVDS-1"; } ];
    desktop.enable = true;
    blueman-applet.enable = false;
  };

  wayland.windowManager.hyprland.settings.input.kb_options = lib.mkForce "ctrl:nocaps,altwin:menu_win";
  # wayland.windowManager.hyprland.settings."$mainMod" = lib.mkForce "ALT_L";
  sops.secrets."ssh/t420".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.t420.public;
}
