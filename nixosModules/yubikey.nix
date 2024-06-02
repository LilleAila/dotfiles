# Basically just followed the steps described in the wiki
# https://nixos.wiki/wiki/Yubikey
# https://rzetterberg.github.io/yubikey-gpg-nixos.html
# https://www.reddit.com/r/yubikey/comments/kfxiue/sign_git_commit_without_entering_pin/
# https://developers.yubico.com/PGP/Card_edit.html
# https://github.com/drduh/YubiKey-Guide
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  options.settings.yubikey.enable = lib.mkEnableOption "yubikey";

  config = lib.mkIf config.settings.yubikey.enable {
    services.udev.packages = [pkgs.yubikey-personalization];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    security.pam.yubico = {
      enable = true;
      # debug = true;
      mode = "challenge-response";
      id = ["26543459"];
    };

    services.pcscd.enable = true;

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      greetd.yubicoAuth = true;
      swaylock.yubicoAuth = true;
    };

    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
    ];
  };
}
