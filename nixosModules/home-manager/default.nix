# NixOS modules that depend upon home-manager
_: {
  imports = [
    ./home-manager.nix
    ./fcitx5.nix
    ./firefox.nix
    ./gaming.nix
  ];
}
