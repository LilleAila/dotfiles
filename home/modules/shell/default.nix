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
    ./neovim.nix
    ./lf.nix
    ./git.nix
    ./zellij.nix
  ];
}
