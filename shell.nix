{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    statix
    sops
    git-crypt
    ripgrep
  ];
}
