{pkgs ? import <nixpkgs> {}}: {
  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  install = pkgs.callPackage ./install.nix {};

  # Doesn't work :(
  # nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
