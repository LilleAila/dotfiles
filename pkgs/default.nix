{pkgs ? import <nixpkgs> {}}: rec {
  box64 = pkgs.callPackage ./box64.nix {};
}
