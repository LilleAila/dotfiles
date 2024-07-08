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
    wm.hyprland.monitors.enable = true;
    desktop.enable = true;
    blueman-applet.enable = true;
  };

  wayland.windowManager.hyprland.settings.input.kb_options = lib.mkForce "ctrl:nocaps,altwin:menu_win";

  # FIXME temporary ssh key, replace with a new one as soon as possible
  sops.secrets."ssh/installer".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.installer.public;

  sops.secrets."yubikey/u2f_keys".path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";

  # Needed to decrypt the other secrets
  home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc;
}
