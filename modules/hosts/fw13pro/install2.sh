#!/usr/bin/env bash
set -euo pipefail

DISK="/dev/nvme0n1"
BOOTDISK="${DISK}p2"
BTRFSDISK="${DISK}p1"

sudo blkdiscard -f "$DISK"
sudo sgdisk -n2:1M:+1G -t2:EF00 "$DISK"
sudo sgdisk -n1:0:0 -t1:8300 "$DISK"
sudo partprobe "$DISK"
sleep 2

sudo mkfs.fat -F 32 -n NIXBOOT "$BOOTDISK"
sudo cryptsetup luksFormat --type luks2 --label NIXCRYPT "$BTRFSDISK"
sudo cryptsetup open --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue --persistent "$BTRFSDISK" cryptroot
BTRFS_DEV="/dev/mapper/cryptroot"

sudo mkfs.btrfs -f -L NIXROOT "$BTRFS_DEV"
sudo mount -t btrfs "$BTRFS_DEV" /mnt
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@cache
sudo btrfs subvolume create /mnt/@persist
sudo umount /mnt

BTRFS_OPTS="compress=zstd,noatime,space_cache=v2"

sudo mount -t tmpfs -o defaults,size=4G,mode=755 none /mnt
sudo mount --mkdir "$BOOTDISK" /mnt/boot
sudo mount --mkdir -o "subvol=@nix,$BTRFS_OPTS" "$BTRFS_DEV" /mnt/nix
sudo mount --mkdir -o "subvol=@cache,$BTRFS_OPTS" "$BTRFS_DEV" /mnt/cache
sudo mount --mkdir -o "subvol=@persist,$BTRFS_OPTS" "$BTRFS_DEV" /mnt/persist
