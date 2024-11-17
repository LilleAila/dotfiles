{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.settings.spacemacs.enable = lib.mkEnableOption "spacemacs";

  config = lib.mkIf config.settings.spacemacs.enable {
    settings.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
    };

    home.file.".emacs.d" = {
      source = inputs.spacemacs;
      recursive = true;
    };

    settings.persist.home.cache = [
      ".emacs.d"
      ".spacemacs.d"
    ];
  };
}
