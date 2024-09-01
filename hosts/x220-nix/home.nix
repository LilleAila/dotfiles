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
        name = "LVDS-1";
        geometry = "1366x768@60";
        position = "0x0";
      }
    ];
    desktop.enable = true;
    desktop.full.enable = true;
    wm.hyprland.monitors.enable = true;

    wm.sway.enable = true;
    wm.hyprpaper.enable = false;
    wm.waybar.enable = true;

    school.enable = true;

    fonts.size = 8;
  };

  home.shellAliases = {
    bt = "bluetooth";
  };

  # caps is ctrl, both shift toggle caps, disable with only one shift, menu key as super
  wayland.windowManager.hyprland.settings.input.kb_options = lib.mkForce "ctrl:nocaps,shift:both_capslock_cancel,altwin:menu_win";

  sops.secrets."ssh/x220".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.x220.public;

  sops.secrets."yubikey/u2f_keys".path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";

  sops.secrets."syncthing/x220/cert".path = "${config.home.homeDirectory}/.config/syncthing/cert.pem";
  sops.secrets."syncthing/x220/key".path = "${config.home.homeDirectory}/.config/syncthing/key.pem";

  # Needed to decrypt the other secrets
  home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc;
}
