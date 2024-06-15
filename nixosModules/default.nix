{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./services

    ./virtualisation.nix
    ./sops.nix
    ./greeter.nix
    ./xserver.nix
    ./locale.nix
    ./user.nix
    ./networking.nix
    ./utils.nix
    ./console.nix
    ./ssh.nix
    ./desktop.nix
    ./nix.nix
    ./sound.nix
    ./gaming.nix
    ./nvidia.nix
    ./yubikey.nix
    ./home-manager.nix
    ./plymouth.nix
    ./zfs.nix
    ./impermanence

    # "home-manager" modules
    # idk if i like this way of doing it, because this means that some things can be enabled even when everything system-wise is disabled
    # possible solution: if both the home option in question and for example `config.settings.enable-hm`
    ./fcitx5.nix
    ./firefox.nix
  ];
}
