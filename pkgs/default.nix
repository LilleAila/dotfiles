{pkgs ? import <nixpkgs> {}}: {
  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};
  nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
