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

    virtualisation.enable = true;

    school.enable = true;
  };

  wayland.windowManager.sway.config.output = {
    "HDMI-A-1" = {
      mode = "2560x1441@144Hz";
      position = "1080 0";
    };
    "DP-2" = {
      mode = "1920x1080@75Hz";
      transform = "270";
      position = "0 0";
    };
  };

  wayland.windowManager.sway.config.workspaceOutputAssign =
    let
      mkWs = workspace: output: {
        inherit output;
        workspace = toString workspace;
      };
    in
    [
      (mkWs 1 "HDMI-A-1")
      (mkWs 2 "HDMI-A-1")
      (mkWs 3 "HDMI-A-1")
      (mkWs 4 "HDMI-A-1")
      (mkWs 5 "HDMI-A-1")
      (mkWs 6 "DP-2")
      (mkWs 7 "DP-2")
      (mkWs 8 "DP-2")
      (mkWs 9 "DP-2")
      (mkWs 10 "DP-2")
    ];

  sops.secrets."ssh/desktop".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.desktop.public;

  # Needed to decrypt the other secrets
  home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc;

  sops.secrets."yubikey/u2f_keys".path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";

  sops.secrets."syncthing/desktop/cert".path = "${config.home.homeDirectory}/.config/syncthing/cert.pem";
  sops.secrets."syncthing/desktop/key".path = "${config.home.homeDirectory}/.config/syncthing/key.pem";
}
