{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: {
  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  wallpaper = pkgs.callPackage ./wallpaper.nix {};

  lutgen-img = pkgs.callPackage ./lutgen-img.nix {
    colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
    image = ../home/wallpapers/wall25.jpg;
  };

  # Works but extremely slow
  # nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
