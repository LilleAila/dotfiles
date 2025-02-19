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

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
    monitors = [ { name = "LVDS-1"; } ];
    desktop.enable = true;
    desktop.full.enable = true;

    wm.sway.enable = true;
    wm.hyprpaper.enable = false;
    wm.waybar.enable = true;

    school.enable = true;
  };

  wayland.windowManager.hyprland.settings.input.kb_options =
    lib.mkForce "ctrl:nocaps,altwin:menu_win";
  sops.secrets."ssh/t420".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.t420.public;
  sops.secrets."syncthing/t420/cert".path =
    "${config.home.homeDirectory}/.config/syncthing/cert.pem";
  sops.secrets."syncthing/t420/key".path = "${config.home.homeDirectory}/.config/syncthing/key.pem";
}
