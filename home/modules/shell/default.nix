{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./zsh.nix
    ./fish.nix
    ./utils.nix
    ./neovim.nix
    ./lf.nix
    ./git.nix
    ./zellij.nix
  ];
}
