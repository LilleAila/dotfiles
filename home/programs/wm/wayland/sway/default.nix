{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.settings.wm.sway = {
    enable = lib.mkEnableOption "swaywm";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.wm.sway.enable) {
      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.swayfx;
      };
    })
  ];
}
