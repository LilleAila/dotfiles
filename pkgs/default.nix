# https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs
{
  pkgs ? import <nixpkgs> { },
  inputs,
  ...
}:
let
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
in
{
  fhsenv = pkgs.callPackage ./fhsenv.nix { };

  wallpaper = pkgs.callPackage ./wallpaper { inherit colorScheme; };

  plymouth-theme = pkgs.callPackage ./plymouth-theme { inherit colorScheme; };

  # None of these work :(
  libfprint-2-tod1-fpc = pkgs.callPackage ./e14g5-fpc.nix { };
  libfprint-fpcmoh = pkgs.callPackage ./libfprint-fpcmoh.nix { };

  # Maybe it's possible to do at runtime instead of compile time?
  anki-nix-colors = pkgs.callPackage ./anki.nix { inherit colorScheme; };

  mobilesheets-companion = pkgs.callPackage ./mobilesheets-companion.nix { };
  mobilesheets-companion2 = pkgs.callPackage ./mobilesheets-companion2.nix { };
}
