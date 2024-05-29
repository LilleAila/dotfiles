# Basically just followed the steps described in the wiki
# https://nixos.wiki/wiki/Yubikey
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
      debug = true;
      mode = "challenge-response";
      id = ["26543459"];
    };

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
