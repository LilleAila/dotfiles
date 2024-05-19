#!/usr/bin/env bash

# nix-shell -p nixFlakes

# Copy the public key and open firefox to authorize with github
# nix run nixpkgs#cage -- -s nix run nixpkgs#firefox -- https://github.com/settings/keys & sleep 2; cat ~/.ssh/id_ed25519 | nix shell nixpkgs#wl-clipboard -c wl-copy
nix-shell -p cage firefox wl-clipboard --run 'cage -s firefox https://github.com/settings/keys & sleep 2; cat ~/.ssh/id_ed25519 | wl-copy'
