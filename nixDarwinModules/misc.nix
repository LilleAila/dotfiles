{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.settings.misc.enable = lib.mkEnableOption "misc";

  config = lib.mkIf config.settings.misc.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    # Reset with updates, has to be reapplied
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
