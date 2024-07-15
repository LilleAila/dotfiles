config:
let
  c = config.colorScheme.palette;
  f = config.settings.fonts;
in
# scss
''
  * {
    font-family: ${f.monospace.name};
    font-size: ${toString f.size}pt;
    color: #${c.base06};
  }

  .control-center {
    background-color: #${c.base00};
    border-radius: 0;
    border: 1px solid #${c.base01};
  }

  .notification {
    border-radius: 0;
  }

  .widget-mpris-player {
    border-radius: 0;
    background-color: rgba(#${c.base01}, 0.55);
    box-shadow: 0px 0px 10px rgba(#${c.base01}, 0.55);

    .widget-mpris-album-art {
      box-shadow: 0px 0px 10px rgba(#${c.base01}, 0.55);
    }
  }
''
# this would be easier if i could override variables in https://github.com/ErikReider/SwayNotificationCenter/blob/main/data/style/style.scss
