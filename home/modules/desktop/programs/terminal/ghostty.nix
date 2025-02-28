{
  config,
  lib,
  ...
}:
{
  options.settings.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf config.settings.ghostty.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = config.colorScheme.slug;
        font-size = 12;
        font-family = "JetBrainsMono Nerd Font";
      };
      themes.${config.colorScheme.slug} = with config.colorScheme.palette; {
        background = base00;
        cursor-color = base06;
        cursor-text = base00;
        foreground = base06;
        selection-background = base03;
        selection-foreground = base06;
        palette = [
          "0=#${base00}"
          "1=#${base08}"
          "2=#${base0B}"
          "3=#${base0A}"
          "4=#${base0D}"
          "5=#${base0E}"
          "6=#${base0C}"
          "7=#${base03}"
          "8=#${base02}"
          "9=#${base08}"
          "10=#${base0B}"
          "11=#${base0A}"
          "12=#${base0D}"
          "13=#${base0E}"
          "14=#${base0C}"
          "15=#${base06}"
        ];
      };
    };
  };
}
