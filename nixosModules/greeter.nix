{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # NOTE: This is not the same options.settings as in home; All options are completely separate
  options.settings.greeter.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (config.settings.greeter.enable) {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
          command =
            pkgs.writeScript "start_tuigreet"
            ''
              ${lib.getExe pkgs.greetd.tuigreet} --cmd Hyprland \
                --time \
                --user-menu \
                --asterisks \
                --container-padding 2 \
                --window-padding 2 \
                --remember \
                --theme ${lib.concatStringsSep ";" [
                # FIXME: Uncomment above line whenever https://github.com/apognu/tuigreet/commit/71cf19e233f990f39b11716a9849c0cf8035b9c3 gets added to nixpkgs
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
              ]}
            '';
        };
      };
      vt = 2;
    };
  };
}
