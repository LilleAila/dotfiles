{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.xserver = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    xwayland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.xserver.enable) {
      services.xserver = {
        enable = true;

        xkb.layout = "no";
        xkb.variant = "";
        displayManager.lightdm.enable = false;

        updateDbusEnvironment = true;
        libinput = {
          enable = true;
          touchpad = {
            naturalScrolling = true;
            disableWhileTyping = true;
          };
        };
        enableCtrlAltBackspace = true;
      };
    })
    (lib.mkIf (config.settings.xserver.xwayland.enable) {
      programs.xwayland.enable = true;
      settings.xserver.enable = true; # Also enable xserver (above)
    })
  ];
}
