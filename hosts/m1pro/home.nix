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
        geometry = "3024x1964@60";
        position = "0x0";
        scale = "2";
      }
    ];
    desktop.enable = true;
    desktop.full.enable = true;

    wm.sway.enable = true;
    wm.hyprpaper.enable = false;
    wm.waybar.enable = true;

    school.enable = true;
  };

  wayland.windowManager.sway.config = {
    output.eDP-1 = {
      scale = "1.6";
      mode = "3024x1964@60Hz";
    };
    # TODO: Create nix option for xkb options
    input."*".xkb_options = lib.mkForce (
      lib.concatStringsSep "," [
        "ctrl:nocaps" # Caps as ctrl
        "shift:both_capslock_cancel"
        "altwin:swap_alt_win"
        "compose:ralt"
      ]
    );
  };

  programs.waybar.settings.bar = {
    height = lib.mkForce 41;
    modules-center = lib.mkForce [ ];
  };

  sops.secrets."yubikey/u2f_keys".path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";
  # home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc;
  sops.secrets."ssh/m1pro".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.m1pro.public;
  sops.secrets."syncthing/m1pro/cert".path =
    "${config.home.homeDirectory}/.config/syncthing/cert.pem";
  sops.secrets."syncthing/m1pro/key".path = "${config.home.homeDirectory}/.config/syncthing/key.pem";
}
