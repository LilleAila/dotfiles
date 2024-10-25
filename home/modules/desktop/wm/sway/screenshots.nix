{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkIf config.settings.wm.sway.enable {
  home.packages = [ inputs.focal.packages.${pkgs.system}.focal-sway ];

  settings.wlr-which-key.menus.ocr =
    let
      item = desc: lang: {
        inherit desc;
        cmd = "focal --area selection --ocr ${lang} --delay 0";
      };
    in
    {
      e = item "English" "eng";
      n = item "Norwegian" "nor";
      f = item "French" "fra";
      j = item "Japanese" "jpn";
      g = item "German" "deu";
      d = item "Danish" "dan";
      s = item "Swedish" "swe";
    };

  wayland.windowManager.sway.config =
    let
      conf = config.wayland.windowManager.sway.config;
      mod = conf.modifier;
    in
    {
      keybindings = {
        "${mod}+s" = "exec focal image --area selection";
        "${mod}+Shift+s" = "exec focal image --area monitor";
        "${mod}+Control+s" = "exec wlr-which-key ocr";

        "${mod}+e" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${mod}+Shift+e" = "exec wl-paste | swappy -f -";
      };
    };
}
