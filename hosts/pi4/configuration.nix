{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
  ...
}: {
  imports = [
    # TODO: Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../.
  ];

  # TODO: look over these options whenever i actually test the config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  settings = {
    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };
    user.name = globalSettings.username;
    networking = {
      enable = true;
      hostname = "nixos-oci";
    };
    utils.enable = true;
    console = {
      font = "ter-u32n";
      keyMap = "no";
    };
    sops.enable = true;
    ssh.enable = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
