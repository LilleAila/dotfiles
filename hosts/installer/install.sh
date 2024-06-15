# TODO: maybe do inside pkgs.writeShellApplication instead of settings home.file and reading those from here
# Sources:
# https://github.com/iynaix/dotfiles/blob/main/install.sh
# https://github.com/iynaix/dotfiles/blob/main/nixos/zfs.nix
# https://github.com/iynaix/dotfiles/blob/main/nixos/impermanence.nix
# https://github.com/iynaix/dotfiles/blob/main/hosts/vm/default.nix#L9
set -e
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


if [[ -b "/dev/vda" ]]; then
  # VM
  DISK="/dev/vda"

  BOOTDISK="${DISK}3"
  SWAPDISK="${DISK}2"
  ZFSDISK="${DISK}1"
else
  # Regular disk
  # TODO
fi

echo "Boot Partiton: $BOOTDISK"
echo "SWAP Partiton: $SWAPDISK"
echo "ZFS Partiton: $ZFSDISK"

do_format=$(yesno "This irreversibly formats the entire disk. Are you sure?")
if [[ $do_format == "n" ]]; then
    exit
fi

echo "Partitioning disk"
sudo blkdiscard -f "$DISK"

sudo sgdisk -n3:1M:+1G -t3:EF00 "$DISK"
sudo sgdisk -n2:0:+16G -t2:8200 "$DISK"
sudo sgdisk -n1:0:0 -t1:BF01 "$DISK"

# notify kernel of partition changes
sudo sgdisk -p "$DISK" > /dev/null
sleep 5

echo "Creating Swap"
sudo mkswap "$SWAPDISK" --label "SWAP"
sudo swapon "$SWAPDISK"

echo "Creating Boot Disk"
sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT

# setup encryption
use_encryption=$(yesno "Use encryption? (Encryption must also be enabled within host config.)")
if [[ $use_encryption == "y" ]]; then
    encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
else
    encryption_options=()
fi

echo "Creating base zpool"
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

echo "Creating /"
sudo zfs create -o mountpoint=legacy zroot/root
sudo zfs snapshot zroot/root@blank
sudo mount -t zfs zroot/root /mnt

# create the boot parition after creating root
echo "Mounting /boot (efi)"
sudo mount --mkdir "$BOOTDISK" /mnt/boot

echo "Creating /nix"
sudo zfs create -o mountpoint=legacy zroot/nix
sudo mount --mkdir -t zfs zroot/nix /mnt/nix

echo "Creating /tmp"
sudo zfs create -o mountpoint=legacy zroot/tmp
sudo mount --mkdir -t zfs zroot/tmp /mnt/tmp

echo "Creating /cache"
sudo zfs create -o mountpoint=legacy zroot/cache
sudo mount --mkdir -t zfs zroot/cache /mnt/cache

echo "Creating /persist"
sudo zfs create -o mountpoint=legacy zroot/persist
sudo mount --mkdir -t zfs zroot/persist /mnt/persist

gpg --import gpg-key.asc
git clone git@github.com:LilleAila/dotfiles
cd dotfiles
git-crypt unlock

# TODO implement choosing hosts (fzf?) and handle case where host does not already exist
# - copy minimal config (vm)
# - generate hardware config (without disks)
# - commit
# - push (gpg and ssh keys are preconfigured on iso)
# - proceed to install
HOST=$(find hosts/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | fzf)
sudo nixos-install --no-root-password --flake .#$HOST
