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

  # Works but extremely slow
  # nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
