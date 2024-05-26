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
        wallpaper = outputs.packages.${pkgs.system}.wallpaper.override {
          scheme = config.colorScheme;
        };
        geometry = "1920x1200@60";
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
  };
  wayland.windowManager.hyprland.settings.input.kb_options = "ctrl:nocaps,altwin:prtsc_rwin";
  home.shellAliases = {
    bt = "bluetooth";
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

  sops.secrets."ssh/e14g5".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.e14g5.public;
}
