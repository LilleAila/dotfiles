{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: {
  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  wallpaper = pkgs.callPackage ./wallpaper.nix {};

  libfprint-2-tod1-fpc = pkgs.callPackage ./e14g5-fpc.nix {};

  rtw89 = pkgs.callPackage ./rtw89.nix {};

  lutgen-img = pkgs.callPackage ./lutgen-img.nix {
    colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
    image = ../home/wallpapers/wall25.jpg;
  };

  # Doesn't work :(
  # nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
