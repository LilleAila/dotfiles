{ self, lib, ... }:
let
  colors = self.lib.colors;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.anki = pkgs.callPackage (
        {
          anki,
          writeTextFile,
          colorScheme,
        }:
        # Maybe it's possible to do with a plugin or something similar, to avoid building from source
        anki.overrideAttrs {
          postPatch = ''
            # This file was renamed to `ts/lib/sass/_color-palette.scss` in later anki versions (that are not packaged in nixpkgs yet)
            rm sass/_color-palette.scss
            cp ${
              writeTextFile {
                name = "_color-palette.scss";
                text =
                  let
                    mkSingleColor = color: ''
                      (
                        0: #${color},
                        1: #${color},
                        2: #${color},
                        3: #${color},
                        4: #${color},
                        5: #${color},
                        6: #${color},
                        7: #${color},
                        8: #${color},
                        9: #${color},
                      )
                    '';
                  in
                  with colorScheme.palette;
                  # scss
                  ''
                    $color-palette: (
                        lightgray: (
                            0: #${base07},
                            1: #${base06},
                            2: #${base05},
                            3: #${base04},
                            4: #${base03},
                            5: #${base02},
                            6: #${base01},
                            7: #${base01},
                            8: #${base00},
                            9: #${base00},
                        ),
                        darkgray: (
                            0: #${base05},
                            1: #${base04},
                            2: #${base03},
                            3: #${base02},
                            4: #${base01},
                            5: #${base00},
                            6: #${base00},
                            7: #${base00},
                            8: #${base00},
                            9: #${base00},
                        ),
                        red: ${mkSingleColor base08},
                        orange: ${mkSingleColor base09},
                        amber: ${mkSingleColor base0F},
                        yellow: ${mkSingleColor base0A},
                        lime: ${mkSingleColor base0B},
                        green: ${mkSingleColor base0B},
                        teal: ${mkSingleColor base0C},
                        cyan: ${mkSingleColor base0D},
                        sky: ${mkSingleColor base0D},
                        blue: ${mkSingleColor base0D},
                        indigo: ${mkSingleColor base0E},
                        violet: ${mkSingleColor base0E},
                        purple: ${mkSingleColor base0E},
                        fuchsia: ${mkSingleColor base0E},
                        pink: ${mkSingleColor base0E},
                    );
                  '';
              }
            } sass/_color-palette.scss
          '';
        }
      ) { inherit (self) colorScheme; };
    };
}
