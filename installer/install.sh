#!/usr/bin/env bash
set -e
source lib.sh

echo "Building NixOS"
read -rp "Press enter to continue "
nixf run nixpkgs#git -- clone git@github:LilleAila/dotfiles $HOME/dotfiles
config_name=$(read -rp "NixOS configuration name: ")
# First run: get SOPS age key from private repo
sudo nixos-rebuild switch --flake $HOME/dotfiles#$(config_name)
# Second run: use the SOPS key to decrypt secrets
sudo nixos-rebuild switch --flake $HOME/dotfiles#$(config_name)
