# Vimjoyer: https://www.youtube.com/watch?v=-G8mN6HJSZE
# `nix build .#nixosConfigurations.installer.config.system.build.isoImage`
# `nix run nixpkgs#nixos-generators -- --format iso --flake .#installer -o result`
{
  config,
  lib,
  pkgs,
  inputs,
  globalSettings,
  modulesPath,
  keys,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../../nixosModules
  ];

  settings = {
    # because bad code
    user.name = "nixos";
    user.enable = false;

    console = {
      font = "ter-u16n";
      keyMap = "no";
    };

    locale = {
      main = "en_US.UTF-8";
      other = "nb_NO.UTF-8";
      timeZone = "Europe/Oslo";
    };

    ssh.enable = true;
    ssh.keys = with keys.ssh; [
      mac.public
      legion.public
      e14g5.public
      t420.public
    ];
  };
  programs.zsh.enable = true;
  users.users.nixos.shell = pkgs.zsh;

  # TODO: make a module (separate from yubikey)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  networking.hostName = "nixos-installer";

  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "x86_64-linux";
}
