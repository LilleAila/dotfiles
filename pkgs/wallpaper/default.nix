{
  lib,
  stdenv,
  inkscape,
  # Colors
  colorScheme,
}:
stdenv.mkDerivation {
  name = "nix-wallpaper-${colorScheme.slug}";
  src = ./template.svg;
  nativeBuildInputs = [
    inkscape
  ];
  unpackPhase = "true";
  buildPhase = let
    c = colorScheme.palette;
    colors = import ../../lib/colors.nix lib;
  in ''
    cp $src ./template.svg
    sed -i "s/#bbbbbb/${colors.format_darken c.base0D 0.9}/g" template.svg
    sed -i "s/#999999/${colors.format_darken c.base0D 0.7}/g" template.svg
    sed -i "s/#777777/${colors.format_darken c.base0D 0.5}/g" template.svg
    sed -i "s/#555555/${colors.format_darken c.base0D 0.4}/g" template.svg
    sed -i "s/#333333/${colors.format_darken c.base0D 0.3}/g" template.svg
    sed -i "s/#222222/${colors.format_darken c.base0D 0.2}/g" template.svg
    # sed -i "s/#222222/#${c.base00}/g" template.svg

    sed -i "s/#ffffff/#${c.base00}/g" template.svg
    sed -i "s/#dddddd/#${c.base01}/g" template.svg

    inkscape template.svg -p -w 1920 -h 1080 -o ./wallpaper.png
  '';
  installPhase = ''
    cp ./wallpaper.png $out
  '';
}
