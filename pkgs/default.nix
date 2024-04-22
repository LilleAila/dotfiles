{pkgs ? import <nixpkgs> {}}: {
  imports = [
    ./cursors
  ];

  box64 = pkgs.callPackage ./box64.nix {};
  fhsenv = pkgs.callPackage ./fhsenv.nix {};

  # Doesn't work :(
  nerdfont_patcher = pkgs.callPackage ./nerdfonts.nix {};

  # Cursors
  google-cursor = pkgs.callPackage ./cursors/google-cursor.nix {};
  fuchsia-cursor = pkgs.callPackage ./cursors/fuchsia-cursor.nix {};
  breeze-cursor = pkgs.callPackage ./cursors/breeze-cursor.nix {};
  apple-cursor = pkgs.callPackage ./cursors/apple-cursor.nix {};
  bibata-original-cursor = pkgs.callPackage ./cursors/bibata-original-cursor.nix {};
}
