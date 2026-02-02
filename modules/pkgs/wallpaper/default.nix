{ self, lib, ... }:
let
  colors = self.lib.colors;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.wallpaper = pkgs.callPackage (
        {
          stdenv,
          inkscape,
          # Colors
          colorScheme,
          bg ? colorScheme.palette.base00,
          fg ? colorScheme.palette.base01,
          accent ? colorScheme.palette.base0D,
          logo ? "none",
          # Arguments
          width ? 1920,
          height ? 1080,
        }:
        stdenv.mkDerivation {
          name = "nix-wallpaper-${colorScheme.slug}-${logo}.png";
          src = ./template_${logo}.svg;
          nativeBuildInputs = [ inkscape ];
          unpackPhase = "true";
          buildPhase =
            let
              c = colorScheme.palette;
            in
            ''
              cp $src ./template.svg
              sed -i "s/#bbbbbb/#${bg}/g" template.svg
              sed -i "s/#999999/#${bg}/g" template.svg
              # sed -i "s/#bbbbbb/${colors.format_darken accent 0.9}/g" template.svg
              # sed -i "s/#999999/${colors.format_darken accent 0.7}/g" template.svg
              sed -i "s/#777777/${colors.format_darken accent 0.5}/g" template.svg
              sed -i "s/#555555/${colors.format_darken accent 0.4}/g" template.svg
              sed -i "s/#333333/${colors.format_darken accent 0.3}/g" template.svg
              sed -i "s/#222222/${colors.format_darken accent 0.2}/g" template.svg

              sed -i "s/#ffffff/#${bg}/g" template.svg
              sed -i "s/#dddddd/#${fg}/g" template.svg

              # hacky way to target only the first one
              sed -i "0,/rgb(0,0,0)/s/rgb(0,0,0)/${colors.format_darken bg 0.4}/" template.svg
              sed -i "s/rgb(0,0,0)/#${bg}/g" template.svg

              inkscape template.svg -p -w ${toString width} -h ${toString height} -o ./wallpaper.png
            '';
          installPhase = ''
            cp ./wallpaper.png $out
          '';
        }
      ) { inherit (self) colorScheme; };
    };
}
