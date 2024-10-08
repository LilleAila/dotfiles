{ lib, colorScheme, ... }:
let
  c = lib.mapAttrs (_: v: "#${v}") colorScheme.palette;
  rgb = lib.mapAttrs (_: v: lib.colors.rgb v) colorScheme.palette;
in # css
''
@define-color accent_color ${c.base0D};
@define-color accent_bg_color ${c.base0D};
@define-color accent_fg_color ${c.base00};
@define-color destructive_color ${c.base08};
@define-color destructive_bg_color ${c.base08};
@define-color destructive_fg_color ${c.base00};
@define-color success_color ${c.base0B};
@define-color success_bg_color ${c.base0B};
@define-color success_fg_color ${c.base00};
@define-color warning_color ${c.base0E};
@define-color warning_bg_color ${c.base0E};
@define-color warning_fg_color ${c.base00};
@define-color error_color ${c.base08};
@define-color error_bg_color ${c.base08};
@define-color error_fg_color ${c.base00};
@define-color window_bg_color ${c.base00};
@define-color window_fg_color ${c.base05};
@define-color view_bg_color ${c.base00};
@define-color view_fg_color ${c.base05};
@define-color headerbar_bg_color ${c.base01};
@define-color headerbar_fg_color ${c.base05};
@define-color headerbar_border_color rgba(${rgb.base01.r}, ${rgb.base01.g}, ${rgb.base01.b}, 0.7);
@define-color headerbar_backdrop_color @window_bg_color;
@define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
@define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
@define-color sidebar_bg_color ${c.base01};
@define-color sidebar_fg_color ${c.base05};
@define-color sidebar_backdrop_color @window_bg_color;
@define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
@define-color secondary_sidebar_bg_color @sidebar_bg_color;
@define-color secondary_sidebar_fg_color @sidebar_fg_color;
@define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
@define-color secondary_sidebar_shade_color @sidebar_shade_color;
@define-color card_bg_color ${c.base01};
@define-color card_fg_color ${c.base05};
@define-color card_shade_color rgba(0, 0, 0, 0.07);
@define-color dialog_bg_color ${c.base01};
@define-color dialog_fg_color ${c.base05};
@define-color popover_bg_color ${c.base01};
@define-color popover_fg_color ${c.base05};
@define-color popover_shade_color rgba(0, 0, 0, 0.07);
@define-color shade_color rgba(0, 0, 0, 0.07);
@define-color scrollbar_outline_color ${c.base02};
@define-color blue_1 ${c.base0D};
@define-color blue_2 ${c.base0D};
@define-color blue_3 ${c.base0D};
@define-color blue_4 ${c.base0D};
@define-color blue_5 ${c.base0D};
@define-color green_1 ${c.base0B};
@define-color green_2 ${c.base0B};
@define-color green_3 ${c.base0B};
@define-color green_4 ${c.base0B};
@define-color green_5 ${c.base0B};
@define-color yellow_1 ${c.base0A};
@define-color yellow_2 ${c.base0A};
@define-color yellow_3 ${c.base0A};
@define-color yellow_4 ${c.base0A};
@define-color yellow_5 ${c.base0A};
@define-color orange_1 ${c.base09};
@define-color orange_2 ${c.base09};
@define-color orange_3 ${c.base09};
@define-color orange_4 ${c.base09};
@define-color orange_5 ${c.base09};
@define-color red_1 ${c.base08};
@define-color red_2 ${c.base08};
@define-color red_3 ${c.base08};
@define-color red_4 ${c.base08};
@define-color red_5 ${c.base08};
@define-color purple_1 ${c.base0E};
@define-color purple_2 ${c.base0E};
@define-color purple_3 ${c.base0E};
@define-color purple_4 ${c.base0E};
@define-color purple_5 ${c.base0E};
@define-color brown_1 ${c.base0F};
@define-color brown_2 ${c.base0F};
@define-color brown_3 ${c.base0F};
@define-color brown_4 ${c.base0F};
@define-color brown_5 ${c.base0F};
@define-color light_1 ${c.base01};
@define-color light_2 ${c.base01};
@define-color light_3 ${c.base01};
@define-color light_4 ${c.base01};
@define-color light_5 ${c.base01};
@define-color dark_1 ${c.base01};
@define-color dark_2 ${c.base01};
@define-color dark_3 ${c.base01};
@define-color dark_4 ${c.base01};
@define-color dark_5 ${c.base01};
''
