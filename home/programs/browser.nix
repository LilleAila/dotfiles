{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./firefox
  ];

  options.settings.browser = {
    qutebrowser.enable = lib.mkEnableOption "qutebrowser";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.browser.qutebrowser.enable) {
      programs.qutebrowser = {
        enable = true;
        settings = {
          colors = import ./qutebrowser_colors.nix {inherit config;};
        };
      };
    })
  ];
}
