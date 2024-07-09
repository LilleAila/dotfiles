{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.settings.gpg.enable = lib.mkEnableOption "gnupg";

  config = lib.mkIf config.settings.gpg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };
}
