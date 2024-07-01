{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.zathura.enable = lib.mkEnableOption "zathura";

  config = lib.mkIf (config.settings.zathura.enable) {
    programs.zathura = with config.colorScheme.palette; {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        recolor = true;
        default-bg = "#${base00}";
        default-fg = "#${base01}";
        statusbar-bg = "#${base02}";
        statusbar-fg = "#${base04}";
        inputbar-bg = "#${base00}";
        inputbar-fg = "#${base07}";
        notification-bg = "#${base00}";
        notification-fg = "#${base07}";
        notification-error-bg = "#${base00}";
        notification-error-fg = "#${base08}";
        notification-warning-bg = "#${base00}";
        notification-warning-fg = "#${base08}";
        highlight-color = "#${base0A}";
        highlight-active-color = "#${base0D}";
        completion-bg = "#${base01}";
        completion-fg = "#${base0D}";
        completion-highlight-fg = "#${base07}";
        completion-highlight-bg = "#${base0D}";
        recolor-lightcolor = "#${base00}";
        recolor-darkcolor = "#${base06}";
      };
    };
  };
}
