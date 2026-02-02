{ lib, ... }:
{
  flake.modules.homeManager.virtualisation =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      options.settings.virtualisation.enable = lib.mkEnableOption "virtualisation";

      config = lib.mkIf config.settings.virtualisation.enable {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
        };

        programs.looking-glass-client = {
          enable = true;
          settings = {
            win = {
              title = "Looking glass (Windows)";
              fullScreen = true;
              noScreensaver = true;
              alerts = false; # hide alerts such as from toggling capture
            };
            input = {
              grabKeyboard = false; # don't capture the keyboard, only the mouse
              # captureOnFocus = true;
              releaseKeysOnFocusLoss = true;
            };
          };
        };
      };
    };
}
