{config, ...}: let
  c = config.colorScheme.palette;
  name = config.colorScheme.slug;
in ''
  [Metadata]
  Name=${name}
  Version=0.1
  Author=LilleAila
  Description=Nix-colors ${name}
  ScaleWithDPI=True

  [InputPanel]
  Font=Sans 10
  NormalColor=#${c.base06}
  HighlightCandidateColor=#${c.base07}
  HighlightColor=#${c.base07}
  HighlightBackgroundColor=#${c.base00}
  Spacing=3

  [InputPanel/TextMargin]
  Left=10
  Right=10
  Top=6
  Bottom=6

  [InputPanel/Background]
  Color=#${c.base00}
  BorderColor=#${c.base01}
  BorderWidth=2

  [InputPanel/Background/Margin]
  Left=2
  Right=2
  Top=2
  Bottom=2

  [InputPanel/Highlight]
  Color=#${c.base01}

  [InputPanel/Highlight/Margin]
  Left=10
  Right=10
  Top=7
  Bottom=7

  [Menu]
  Font=Sans 10
  NormalColor=#${c.base06}
  HighlightColor=#${c.base01}
  Spacing=3

  [Menu/Background]
  Color=#${c.base00}

  [Menu/Background/Margin]
  Left=2
  Right=2
  Top=2
  Bottom=2

  [Menu/ContentMargin]
  Left=2
  Right=2
  Top=2
  Bottom=2

  [Menu/Highlight]
  Color=#${c.base01}

  [Menu/Highlight/Margin]
  Left=10
  Right=10
  Top=5
  Bottom=5

  [Menu/Separator]
  Color=#${c.base01}

  [Menu/CheckBox]
  Image=radio.png

  [Menu/SubMenu]
  Image=arrow.png

  [Menu/TextMargin]
  Left=5
  Right=5
  Top=5
  Bottom=5
''
