{
  config,
  pkgs,
  inputs,
  lib,
  globalSettings,
  ...
}: {
  home = {
    username = "${globalSettings.username}";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
  };

  imports = [
    ./modules
  ];
}
