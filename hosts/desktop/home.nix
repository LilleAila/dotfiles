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

  # https://github.com/tinted-theming/base16-schemes/
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
    monitors = [
      {
        name = "HDMI-A-1";
        geometry = "1920x1080@75";
        position = "0x0";
      }
    ];
    gaming.enable = true;
    gaming.steam.enable = true;
    desktop.enable = true;
    desktop.full.enable = true;
    wm.hyprland.monitors.enable = true;

    wm.sway.enable = true;
    wm.hyprpaper.enable = false;
    wm.waybar.enable = true;
  };

  sops.secrets."ssh/desktop".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.desktop.public;

  # Needed to decrypt the other secrets
  home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc;

  sops.secrets."yubikey/u2f_keys".path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";
}
