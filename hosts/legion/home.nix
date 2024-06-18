{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  keys,
  ...
}: {
  imports = [../../home];

  settings = {
    monitors = [
      {
        name = "eDP-1";
        # wallpaper = ./wallpapers/wall10.jpg;
        # wallpaper = ./wallpapers/wall24.png;
        wallpaper = outputs.packages.${pkgs.system}.wallpaper.override {
          scheme = config.colorScheme;
        };
        geometry = "1920x1080@60";
        position = "0x0";
      }
    ];
    desktop.enable = true;
    nix.unfree = [
      "1password"
      "1password-gui"
      "geogebra"
    ];
    wm.hyprland.monitors.enable = true;
    wm.hyprland.useFlake = true;

    gaming.enable = true;
    gaming.steam.enable = true;
  };
  wayland.windowManager.hyprland.settings.input = {
    kb_options = "ctrl:nocaps,altwin:prtsc_rwin";
  };
  home.shellAliases = {
    bat-fullcharge = "sudo tlp fullcharge";
    bat-limit = "sudo tlp setcharge 0 1 BAT0";
    bt = "bluetooth";
    osbuild = let
      base_cmd = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dotfiles";
    in
      (pkgs.writeShellScript "osbuild" ''
        #!/usr/bin/env bash
        if [ -z "''${NIXOS_ACTIVE_SPECIALISATION}" ] || [ "''${NIXOS_ACTIVE_SPECIALISATION}" = "default" ]; then
            ${base_cmd}
        else
            ${base_cmd} --specialisation "''${NIXOS_ACTIVE_SPECIALISATION}"
        fi
      '')
      .outPath;
  };
  home.packages = with pkgs; [
    _1password-gui-beta
    protonvpn-gui
    fluidsynth
    qsynth
    inkscape
    (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (ps:
      with ps; [
        plover_uinput
        plover-lapwing-aio
      ]))
    geogebra6
  ];

  settings.persist.home.cache = [".config/inkscape"];

  sops.secrets."ssh/legion".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.legion.public;
  sops.secrets."syncthing/legion/cert".path = "${config.home.homeDirectory}/.config/syncthing/cert.pem";
  sops.secrets."syncthing/legion/key".path = "${config.home.homeDirectory}/.config/syncthing/key.pem";
}
