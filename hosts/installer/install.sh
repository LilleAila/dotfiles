#!/usr/bin/env bash
set -e

# For this script to work, you need at least:
# - A sops key in secrets/sops-key.txt (can be encrypted with git-crypt)
# - A gpg private key export in home.file."gpg-key.asc"
# - A configuration that supports the filesystems described below

repo_url="git@github.com:LilleAila/dotfiles"
default_user="olai"

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

function info() {
  # 35 is magenta
  echo -e "\e[1;35m$1\e[0m"
}

info "Checking internet connection..."
if ping -c 1 "8.8.8.8" &> /dev/null; then
    echo "Internet connection is up."
else
  cat << Network
Your network is disconnected. Connect using the following commands, then re-run the installer:
sudo su
wpa_supplicant -B -i wlp3n0 -c <(wpa_passphrase ESSID key)
exit
, replacing ESSID and key with the ESSID and key of your network
Network
  exit 1
fi

cat << Introduction

This script will format the *entire* disk with a 1GB boot partition
(labelled NIXBOOT), 16GB of swap, then allocating the rest to ZFS.

The following ZFS datasets will be created:
    - zroot/root (mounted at / with blank snapshot)
    - zroot/nix (mounted at /nix)
    - zroot/tmp (mounted at /tmp)
    - zroot/persist (mounted at /persist)
    - zroot/persist/cache (mounted at /persist/cache)

Introduction

while true; do
  info "Available disks:"
  lsblk -do NAME,SIZE,TYPE,MODEL
  read -p "The NAME of the disk to format: " DISKINPUT
  DISK="/dev/${DISKINPUT}"
  if [ -b "$DISK" ]; then
    echo -e "\e[1;35mSelected disk:\e[0m $DISKINPUT"
    break
  else
    info "Invalid disk name $DISKINPUT"
  fi
done
if [[ $DISKINPUT == nvme* ]]; then
  BOOTDISK="${DISK}p3"
  SWAPDISK="${DISK}p2"
  ZFSDISK="${DISK}p1"
else
  BOOTDISK="${DISK}3"
  SWAPDISK="${DISK}2"
  ZFSDISK="${DISK}1"
fi

info "Boot Partiton: $BOOTDISK"
info "SWAP Partiton: $SWAPDISK"
info "ZFS Partiton: $ZFSDISK"

do_format=$(yesno "This irreversibly formats the entire disk. Are you sure?")
if [[ $do_format == "n" ]]; then
    exit
fi

info "Partitioning disk"
sudo blkdiscard -f "$DISK"

sudo sgdisk -n3:1M:+1G -t3:EF00 "$DISK"
sudo sgdisk -n2:0:+16G -t2:8200 "$DISK"
sudo sgdisk -n1:0:0 -t1:BF01 "$DISK"

# notify kernel of partition changes
sudo sgdisk -p "$DISK" > /dev/null
sleep 5

info "Creating Swap"
sudo mkswap "$SWAPDISK" --label "SWAP"
sudo swapon "$SWAPDISK"

info "Creating Boot Disk"
sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT

# setup encryption
use_encryption=$(yesno "Use encryption?")
if [[ $use_encryption == "y" ]]; then
    encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
else
    encryption_options=()
fi

info "Creating base zpool"
sudo zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O compression=zstd \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O normalization=formD \
    -O mountpoint=none \
    "${encryption_options[@]}" \
    zroot "$ZFSDISK"

info "Creating /"
sudo zfs create -o mountpoint=legacy zroot/root
sudo zfs snapshot zroot/root@blank
sudo mount -t zfs zroot/root /mnt

# create the boot parition after creating root
info "Mounting /boot (efi)"
sudo mount --mkdir "$BOOTDISK" /mnt/boot

info "Creating /nix"
sudo zfs create -o mountpoint=legacy zroot/nix
sudo mount --mkdir -t zfs zroot/nix /mnt/nix

info "Creating /tmp"
sudo zfs create -o mountpoint=legacy zroot/tmp
sudo mount --mkdir -t zfs zroot/tmp /mnt/tmp

info "Creating /cache"
sudo zfs create -o mountpoint=legacy zroot/cache
sudo mount --mkdir -t zfs zroot/cache /mnt/cache

info "Creating /persist"
sudo zfs create -o mountpoint=legacy zroot/persist
sudo mount --mkdir -t zfs zroot/persist /mnt/persist

info "Importing GPG key"
gpg --import gpg-key.asc
info "Cloning configuration"
git clone "$repo_url" dotfiles
cd $HOME/dotfiles
info "Decrypting secrets"
git-crypt unlock

info "Choose which host to install (this can take some time to load)"
info "Press enter to continue..."
read
HOST=$(echo "Configure a new host
Install existing host with minimal config" | cat - <(nix flake show . --json 2>/dev/null | jq --raw-output '.nixosConfigurations | keys[]') | fzf --header="Choose a host to install")
echo

if [ "$HOST" == "Configure a new host" ]; then
  info "Configuring new host..."
  read -rp "Name for the new host: " HOST_NAME
  cp -r hosts/template "hosts/$HOST_NAME"
  sudo nixos-generate-config --no-filesystems --show-hardware-config > "hosts/$HOST_NAME/hardware-configuration.nix"
  info "Editing configuration.nix"
  info "Press enter to continue..."
  read
  if [[ $use_encryption == "y" ]]; then
    sed -i '/zfs.encryption/s/false/true/' "hosts/$HOST_NAME/configuration.nix"
  fi
  hostId="$(head -c 8 /etc/machine-id)"
  sed -i "/networking.hostId/s/placeholder/$hostId/" "hosts/$HOST_NAME/configuration.nix"
  sed -i "/hostname/s/placeholder/$HOST_NAME/" "hosts/$HOST_NAME/configuration.nix"
  nvim "hosts/$HOST_NAME/configuration.nix"
  info "Adding configuration to flake.nix"
  sed -i "/nixosConfigurations = {/a \ \ \ \ \ \ $HOST_NAME = mkConfig {name = \"$HOST_NAME\";};" flake.nix
  info "Commiting changes"
  git add -A
  git commit -m "Hosts: added $HOST_NAME"
  git push
  info "Installing NixOS configuration for host $HOST_NAME"
elif [ "$HOST" == "Install existing host with minimal config" ]; then
  info "TODO"
else
  info "Installing NixOS configuration for host $HOST"
  HOST_NAME=$HOST
fi

info "Finished pre-install."
do_install=$(yesno "Install NixOS?")
if [[ $do_install == "y" ]]; then
  sudo nixos-install --no-root-password --flake .#$HOST_NAME --impure
  info "Finished install."
fi
