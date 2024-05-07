{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./files.nix
    ./fonts.nix
    ./other.nix
    ./zathura.nix
    ./espanso
  ];
}
