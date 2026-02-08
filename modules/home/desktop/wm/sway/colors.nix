{ lib, ... }:
{
  flake.modules.homeManager.sway-colors =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    lib.mkIf config.settings.wm.sway.enable {
      wayland.windowManager.sway.config = {

        colors =
          let
            c = config.colorScheme.palette;
          in
          {
            background = "#${c.base00}";
            focused = {
              border = "#${c.base05}";
              childBorder = "#${c.base05}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
            };
            focusedInactive = {
              border = "#${c.base02}";
              childBorder = "#${c.base02}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
            };
            unfocused = {
              border = "#${c.base01}";
              childBorder = "#${c.base01}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
            };
            urgent = {
              border = "#${c.base0A}";
              childBorder = "#${c.base02}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
            };
            placeholder = {
              border = "#${c.base01}";
              childBorder = "#${c.base02}";
              background = "#${c.base00}";
              text = "#${c.base06}";
              indicator = "#${c.base00}";
            };
          };
      };
    };
}
