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
        wallpaper = ./wallpapers/wall3.jpg;
      }
      {
        name = "HDMI-A-1";
        wallpaper = ./wallpapers/wall18.jpg;
      }
    ];
    desktop.enable = true;
    wm.hyprland.useFlake = false;
  };

  # Local shell aliases
  home.shellAliases = {
    bat-fullcharge = "echo 100 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    bat-limit = "echo 80 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    # osbuild = lib.mkForce "nh os switch -- --impure";
    osbuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dotfiles --fast --no-build-nix --impure";
  };

  wayland.windowManager.hyprland.settings.env = ["GDK_SCALE,2"];

  home.packages = with pkgs; [
    outputs.packages.${pkgs.system}.box64
    outputs.packages.${pkgs.system}.fhsenv

    _1password-gui-beta
    handbrake

    (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (ps:
      with ps; [
        plover_uinput
      ]))

    geogebra6
    lmms
    musescore
    inkscape
    prismlauncher
  ];

  sops.secrets."ssh/mac".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.mac.public;
}
