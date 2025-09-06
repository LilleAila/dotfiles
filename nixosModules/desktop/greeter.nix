{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.greeter = {
    enable = lib.mkEnableOption "greeter";
    command = lib.mkStrOption "niri-session";
  };

  config = lib.mkIf config.settings.greeter.enable {
    settings.persist.root.cache = [ "/var/cache/tuigreet" ];
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = pkgs.writeScript "start_tuigreet" ''
            ${lib.getExe pkgs.tuigreet} --cmd ${config.settings.greeter.command} \
              --time \
              --user-menu \
              --asterisks \
              --container-padding 2 \
              --window-padding 2 \
              --remember \
              --theme ${
                lib.concatStringsSep ";" [
                  # Colors for the TTY are defined in nixosModules/utils.nix
                  "text=white"
                  "time=white"
                  "container=darkgray"
                  "border=green"
                  "title=magenta"
                  "greet=magenta"
                  "prompt=white"
                  "input=gray"
                  "action=gray"
                  "button=cyan"
                ]
              }
          '';
        };
      };
    };
  };
}
