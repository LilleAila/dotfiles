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
}:
{
  options.settings.yubikey.enable = lib.mkEnableOption "yubikey";

  config = lib.mkIf config.settings.yubikey.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];

    security.pam.yubico = {
      enable = true;
      # debug = true;
      mode = "challenge-response";
      id = [ "26543459" ];
    };

    services.pcscd.enable = true;

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      greetd.yubicoAuth = true;
      swaylock.yubicoAuth = true;
    };

    # FIXME: Temporarily disabled because of https://github.com/NixOS/nixpkgs/issues/352598
    # Fixed in https://nixpk.gs/pr-tracker.html?pr=353230 , but not yet in unstable
    # likely applies to all packages, not just yubikey-manager
    environment.systemPackages = with pkgs; [
      # yubioath-flutter
      # yubikey-manager
      # yubikey-manager-qt
      # yubikey-personalization
      # yubikey-personalization-gui
    ];
  };
}
