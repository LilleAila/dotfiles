{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
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
    ./steam.nix
    ./nvidia.nix
  ];
}
