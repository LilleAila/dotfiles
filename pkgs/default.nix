{pkgs ? import <nixpkgs> {}}: {
  imports = [
    ./cursors
  ];

  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};
  nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};
  # cbmp = pkgs.callPackage ./cbmp.nix {};
  google-cursor = pkgs.callPackage ./cursors/google-cursor.nix {};
}
