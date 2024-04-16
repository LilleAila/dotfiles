{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./zsh.nix
    ./fish.nix
    ./shell.nix
    ./terminal.nix
    ./neovim.nix
    ./lf.nix
    ./git.nix
    ./zellij.nix
  ];
}
