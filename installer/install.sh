#!/usr/bin/env bash

set -e

function nixf() {
  nix --extra-experimental-features "nix-command-flakes" "$@"
}

function yesno() {
    local prompt="$1"

    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

git clone git@github.com:LilleAila/dotfiles

# TODO: stop using two repositories. This causes circular dependencies
new=$(yesno "Set up a new host?")
if [[ $new == "y" ]]; then
    echo "Generating new SSH key for this machine"
    read -rp "Press enter to continue "
    nixf shell nixpkgs#openssh -c ssh-keygen -t ed25519 $(read -rp "SSH key description")
    echo "Opening GitHub with your public key in the clipboard"
    echo "Add thhe SSH key to your authorized keys"
    read -rp "Press enter to continue "
    nixf run nixpkgs#cage -- -s nixf run nixpkgs#firefox -- https://github.com/settings/keys & sleep 2; cat ~/.ssh/id_ed25519 | nixf shell nixpkgs#wl-clipboard -c wl-copy
    # TODO: make this copy a simple configuration template
else
    has_keys=$(yesno "Do you have SSH keys set up properly?")
    if [[ $has_keys == "n" ]]; then
        echo "You need to set up SSH keys before installing!"
        exit
    fi
fi

echo "Building NixOS"
read -rp "Press enter to continue "
nixf run nixpkgs#git -- clone git@github:LilleAila/dotfiles $HOME/dotfiles
config_name=$(read -rp "NixOS configuration name: ")
# First run: get SOPS age key from private repo
sudo nixos-rebuild switch --flake $HOME/dotfiles#$(config_name)
# Second run: use the SOPS key to decrypt secrets
sudo nixos-rebuild switch --flake $HOME/dotfiles#$(config_name)
