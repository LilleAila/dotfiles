{pkgs ? import <nixpkgs> {}}: {
  imports = [
    ./cursors
  ];

  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  # Doesn't work :(
  nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
}
