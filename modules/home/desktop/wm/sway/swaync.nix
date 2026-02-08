{ self, lib, ... }:
{
  flake.modules.homeManager.swaync =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {

      options.settings.wm.swaync.enable = lib.mkEnableOption "swaync";

      config = lib.mkIf config.settings.wm.swaync.enable {
        services.swaync = {
          enable = true;
          settings = {
            positionX = "right";
            positionY = "top";
            notification-2fa-action = true;
            fit-to-screen = false;
            control-center-width = 500;
            control-center-height = 800;
            control-center-margin-top = 16;
            control-center-margin-right = 16;
            widgets = [
              "mpris"
              "title"
              "dnd"
              "notifications"
            ];
          };

          style = pkgs.stdenv.mkDerivation {
            name = "style.css";
            nativeBuildInputs = [ pkgs.sass ];
            src = pkgs.writeText "style.scss" (
              import ./_swaync-style.nix {
                inherit (self) colorScheme;
                inherit config pkgs;
              }
            );
            unpackPhase = "true";
            buildPhase = ''
              sass $src $out
            '';
          };

        };

        # Required for waybar to recognise the program properly
        # FIXME: maybe just start waybar from sway instead of through systemd (disable systemd.enable in waybar)
        systemd.user.services.waybar.Service.Environment = lib.mkForce "PATH=${
          lib.makeBinPath [ config.services.swaync.package ]
        }";

        wayland.windowManager.sway.config.keybindings = {
          "XF86Messenger" = "exec swaync-client -t -sw";
        };
      };
    };
}
