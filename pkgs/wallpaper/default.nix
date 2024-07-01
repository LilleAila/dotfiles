{
  lib,
  stdenv,
  inkscape,
  # Colors
  colorScheme,
  # Arguments
  width ? 1920,
  height ? 1080,
}:
stdenv.mkDerivation {
  name = "nix-wallpaper-${colorScheme.slug}";
  src = ./template.svg;
  nativeBuildInputs = [ inkscape ];
  unpackPhase = "true";
  buildPhase =
    let
      c = colorScheme.palette;
      colors = import ../../lib/colors.nix lib;
      baseColor = c.base0D;
    in
    ''
      cp $src ./template.svg
      sed -i "s/#bbbbbb/#${c.base00}/g" template.svg
      sed -i "s/#999999/#${c.base00}/g" template.svg
      # sed -i "s/#bbbbbb/${colors.format_darken baseColor 0.9}/g" template.svg
      # sed -i "s/#999999/${colors.format_darken baseColor 0.7}/g" template.svg
      sed -i "s/#777777/${colors.format_darken baseColor 0.5}/g" template.svg
      sed -i "s/#555555/${colors.format_darken baseColor 0.4}/g" template.svg
      sed -i "s/#333333/${colors.format_darken baseColor 0.3}/g" template.svg
      sed -i "s/#222222/${colors.format_darken baseColor 0.2}/g" template.svg

      sed -i "s/#ffffff/#${c.base00}/g" template.svg
      sed -i "s/#dddddd/#${c.base01}/g" template.svg

      # hacky way to target only the first one
      sed -i "0,/rgb(0,0,0)/s/rgb(0,0,0)/${colors.format_darken c.base00 0.4}/" template.svg
      sed -i "s/rgb(0,0,0)/#${c.base00}/g" template.svg

      inkscape template.svg -p -w ${toString width} -h ${toString height} -o ./wallpaper.png
    '';
  installPhase = ''
    cp ./wallpaper.png $out
  '';
}
