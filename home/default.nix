{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home = {
    username = "olai";
    homeDirectory = "/home/olai";
    stateVersion = "23.11";
  };

  imports = [
    ./modules
  ];
}
