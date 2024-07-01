{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.browser = {
    qutebrowser.enable = lib.mkEnableOption "qutebrowser";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.browser.qutebrowser.enable) {
      programs.qutebrowser = {
        enable = true;
        settings = {
          colors = import ./colors.nix { inherit config; };
          fonts = with config.settings.fonts; {
            default_family = sansSerif.name;
            default_size = "${toString size}pt";
            web = {
              family = {
                cursive = serif.name;
                fantasy = serif.name;
                fixed = monospace.name;
                sans_serif = sansSerif.name;
                serif = serif.name;
                standard = sansSerif.name;
              };
              # https://github.com/danth/stylix/blob/f1bb5c5080685b0b18c7fdff091e5278353ba39d/modules/qutebrowser/hm.nix#L276
              size.default = builtins.floor (size * 4 / 3 + 0.5);
            };
          };
        };
      };
    })
  ];
}
