{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkIf config.settings.wm.sway.enable {
  settings.wlr-which-key = {
    enable = true;
    settings =
      let
        c = config.colorScheme.palette;
        f = config.settings.fonts;
      in
      {
        font = "${f.monospace.name} ${toString (lib.fonts.round (f.size * 1.5))}";
        background = "#${c.base00}";
        color = "#${c.base06}";
        border = "#${c.base01}";
        border_width = 1;
        corner_r = 0;
        padding = 16;
        separator = " -> ";

        anchor = "bottom-right";
        margin_right = 64;
        margin_bottom = 64;
        margin_left = 0;
        margin_top = 0;
      };
  };
}
