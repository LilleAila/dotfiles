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
  # imports = [
  #   inputs.hypridle.homeManagerModules.hypridle
  # ];

  options.settings.wm.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.settings.wm.hypridle.enable) {
    services.hypridle = {
      enable = true;
      settings = rec {
        general = {
          before_sleep_cmd = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
          ignore_dbus_inhibit = false;
          # lock_cmd = lib.getExe config.programs.hyprlock.package;
          lock_cmd = lib.getExe config.programs.swaylock.package;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = general.lock_cmd;
          }
          {
            timeout = 600;
            # TODO: replace with hyprctl dispatch dpms off/on && systemctl suspend
            on-timeout = suspendScript.outPath;
          }
        ];
      };
    };
  };
}
