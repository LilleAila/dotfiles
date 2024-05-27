{
  stdenv,
  lutgen,
  writeTextFile,
  lib,
  #
  colorScheme,
  image,
}:
stdenv.mkDerivation {
  name = "lutgen-image";
  src = writeTextFile {
    name = "colorscheme.txt";
    text = lib.concatStringsSep "\n" (lib.mapAttrsToList (a: b: "#${b}") colorScheme.palette);
  };
  unpackPhase = "true";
  nativeBuildInputs = [
    lutgen
  ];
  buildPhase = ''
    lutgen apply ${image} -- $(cat $src)
  '';
  installPhase = ''
    cp custom/$(basename ${image}) $out
  '';
}
