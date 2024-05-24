{pkgs ? import <nixpkgs> {}}: {
  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  wallpaper = pkgs.callPackage ./wallpaper.nix {};

  libfprint-2-tod1-fpc = pkgs.callPackage ./e14g5-fpc.nix {};

  # Doesn't work :(
  # nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
