# (this doesn't work)
{
  pkgs,
  stdenv,
  lib,
  nerd-font-patcher,
  fetchzip,
  ...
}:
font:
# Input is a font package from nixpkgs
stdenv.mkDerivation {
  name = "${font.name}-nerd-font-patched";

  nativeBuildInputs = [ nerd-font-patcher ];

  src = font;

  buildPhase = ''
    find \( -name \*.ttf -o -name \*.otf \) -execdir nerd-font-patcher -c {} \;
  '';

  installPhase = ''
    mkdir -p $out
    cp -a . $out
  '';
}
