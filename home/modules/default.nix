{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./shell
    ./desktop
    ./other

    # inputs.sops-nix.homeManagerModules.sops # i no no wanna set up :( using in system works fine
    inputs.nix-colors.homeManagerModules.default
  ];
}
