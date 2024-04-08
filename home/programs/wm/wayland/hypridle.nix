{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  options.settings.wm.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.settings.wm.hypridle.enable) {
    services.hypridle = {
      enable = true;
      beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
      # lockCmd = lib.getExe config.programs.hyprlock.package;
      lockCmd = lib.getExe config.programs.swaylock.package;

      listeners = [
        {
          timeout = 330;
          onTimeout = suspendScript.outPath;
        }
      ];
    };
  };
}
