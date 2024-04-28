{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixosModules
    ../../nixosModules/asahi # This causes problems when imported globally
  ];

  system.stateVersion = "24.05";

  settings = {
    asahi.enable = true;
    greeter.enable = true;
    xserver.xwayland.enable = true;
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    # user.shell = pkgs.fish;
    user.shell = pkgs.zsh;
    networking = {
      enable = true;
      hostname = "mac-nix";
      wifi.enable = true;
      bluetooth.enable = true;
    };
    utils.enable = true;
    desktop.enable = true;
    tlp.enable = false;
    console = {
      font = "ter-u32n";
      keyMap = "no";
    };
    sops.enable = true;
    nix.unfree = [
      "geogebra"
      "1password"
      "1password-gui"
      "factorio"
      "factorio-demo"
    ];
  };
}
