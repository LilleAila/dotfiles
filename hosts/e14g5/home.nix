{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  keys,
  ...
}:
{
  imports = [ ../../home ];

  settings = {
    monitors = [
      {
        name = "eDP-1";
        geometry = "1920x1200@60";
        position = "0x0";
      }
    ];
    gaming.enable = true;
    gaming.steam.enable = true;
    desktop.enable = true;
    desktop.full.enable = true;
    wm.hyprland.monitors.enable = true;
    emacs.enable = false;

    niri.enable = true;

    wm.sway.enable = true;
    wm.hyprpaper.enable = false;
    wm.waybar.enable = true;

    school.enable = true;
  };
  wayland.windowManager.hyprland.settings.input.kb_options = "ctrl:nocaps,altwin:prtsc_rwin";
  home.shellAliases = {
    bt = "bluetooth";
  };

  sops.secrets."yubikey/u2f_keys".path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";
  sops.secrets."ssh/e14g5".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.e14g5.public;
  # home.file.".ssh/yubikey.pub".text = keys.ssh.yubikey.public;
  sops.secrets."syncthing/e14g5/cert".path = "${config.home.homeDirectory}/.config/syncthing/cert.pem";
  sops.secrets."syncthing/e14g5/key".path = "${config.home.homeDirectory}/.config/syncthing/key.pem";
}
