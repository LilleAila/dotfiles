{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nixfmt
    statix
    sops
    git-crypt
    ripgrep
  ];
}
