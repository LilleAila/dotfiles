# https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs
{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: let
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
in {
  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  wallpaper = pkgs.callPackage ./wallpaper.nix {inherit colorScheme;};
  wallpaper2 = pkgs.callPackage ./wallpaper {inherit colorScheme;};

  lutgen-img = pkgs.callPackage ./lutgen-img.nix {
    inherit colorScheme;
    image = ../home/wallpapers/wall25.jpg;
  };

  plymouth-theme = pkgs.callPackage ./plymouth-theme {inherit colorScheme;};

  libfprint-2-tod1-fpc = pkgs.callPackage ./e14g5-fpc.nix {};
  libfprint-fpcmoh = pkgs.callPackage ./libfprint-fpcmoh.nix {};

  anki-nix-colors = pkgs.callPackage ./anki.nix {inherit colorScheme;};

  # Works but extremely slow
  # nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
