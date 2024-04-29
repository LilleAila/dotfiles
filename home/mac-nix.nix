{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./.
  ];

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
    wayfire.enable = true;
    desktop.enable = true;
  };

  # Local shell aliases
  home.shellAliases = {
    bat-fullcharge = "echo 100 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    bat-limit = "echo 80 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
    osbuild = lib.mkForce "nh os switch -- --impure";
  };

  home.packages = with pkgs; [
    outputs.packages.${pkgs.system}.box64
    outputs.packages.${pkgs.system}.fhsenv

    _1password-gui-beta
    handbrake

    (inputs.plover-flake.packages.${pkgs.system}.plover.with-plugins (ps:
      with ps; [
        plover-uinput
      ]))

    geogebra6
    lmms
    musescore
    inkscape
  ];

  settings.webapps.chromium = {
    CSTimer = {
      icon = "alarm-timer";
      url = "https://cstimer.net";
    };
    Monkeytype = {
      icon = "input-keyboard-symbolic";
      url = "https://monkeytype.com";
    };
  };

  home.sessionVariables."PLOVER_UINPUT_LAYOUT" = "no";
}
