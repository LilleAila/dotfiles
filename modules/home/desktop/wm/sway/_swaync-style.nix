{
  colorScheme,
  config,
  pkgs,
}:
let
  c = colorScheme.palette;
  f = config.settings.fonts;
in
# scss
''
  $border: 1px solid #${c.base01};
  $border-radius: 0;
  $font-size-body: ${toString f.size}pt;
  $font-size-summary: ${toString f.size}pt;
  $margin: 4px;

  $hover-tranistion: none;
  $group-collapse-tranistion: none;
  $notification-shadow: none;
  $mpris-shadow: none;

  @define-color cc-bg #${c.base00};
  @define-color noti-border-color #${c.base01};
  @define-color noti-bg #${c.base00};
  @define-color noti-bg-opaque #${c.base00};
  @define-color noti-bg-darker #${c.base00};
  @define-color noti-bg-hover #{mix(#${c.base00}, #${c.base01}, 80%)};
  @define-color noti-bg-hover-opaque #{mix(#${c.base00}, #${c.base01}, 80%)};
  @define-color noti-bg-focus #${c.base00};
  @define-color noti-close-bg #${c.base00};
  @define-color noti-close-bg-hover #${c.base01};
  @define-color text-color #${c.base06};
  @define-color text-color-disabled #${c.base04};
  @define-color bg-selected #${c.base01};
  @define-color mpris-album-art-overlay #${c.base00};
  @define-color mpris-button-hover #${c.base01};

  // Could also just do something like this: https://sass-lang.com/documentation/at-rules/use/#reassigning-variables
  @import '${
    pkgs.stdenv.mkDerivation {
      name = "swaync-css-override-vars";
      src = pkgs.fetchFromGitHub {
        owner = "ErikReider";
        repo = "SwayNotificationCenter";
        rev = "653058beacbbcebf0e400afc7d3b68cb0ed74f1f";
        hash = "sha256-xgCqIh4yEqxRe4D9ELgnosOWT43HEWS3bPYlqvBoj3Y=";
      };
      buildPhase = ''
        # find ./data/style/ -type f -exec sed -i 's/\(\$[^:]*: [^;]*\);\(.*\)/\1 !default;\2/' {} +
        find ./data/style/ -type f -exec sed -i '/\$.*: .*;/d' {} +
        find ./data/style/ -type f -exec sed -i '/@define-color .*;$/d' {} +
      '';
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out/
      '';
    }
  }/data/style/style';

  * {
    font-family: ${f.monospace.name};
  }

  .control-center {
    // same as border for focused window in sway
    border: 1px solid #${c.base05};
  }

  .widget-mpris-player {
    border: $border;
  }

  .control-center .control-center-list .notification {
    box-shadow: none;
  }
''
