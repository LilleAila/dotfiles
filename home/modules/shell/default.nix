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
    ./utils.nix
    ./neovim.nix
    ./lf.nix
    ./git.nix
    ./zellij.nix
  ];
}
