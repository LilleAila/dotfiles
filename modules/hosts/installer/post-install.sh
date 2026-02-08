#!/usr/bin/env bash
set -e

default_user="olai"

function info() {
  # 35 is magenta
  echo -e "\e[1;35m$1\e[0m"
}


info "Copying secrets"
# This assumes the user ID and group ID are set properly for the user
# In the case of my own configuration, it is :)
printf "\033[1;33mUsername of the main user ($default_user):\033[0m "
read username
if [ -z "$username" ]; then
  username="$default_user"
fi
sudo mkdir -p "/mnt/cache/home/$username/.config/sops/age"
sudo cp secrets/sops-key.txt "/mnt/cache/home/$username/.config/sops/age/keys.txt"
sudo cp secrets/gpg-key.asc "/mnt/cache/home/$username/"
sudo chown -R 1000:100 "/mnt/cache/home/$username"
sudo mkdir -p "/mnt/persist/home/$username"
sudo chown -R 1000:100 "/mnt/persist/home/$username"
info "Finished post-install."
