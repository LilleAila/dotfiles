{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  emacs-package = inputs.emacs-config.packages.${pkgs.system}.emacs.override {
    inherit (config) colorScheme;
  };
in
{
  options.settings.emacs.enable = lib.mkEnableOption "emacs";

  config = lib.mkIf config.settings.emacs.enable {
    programs.emacs = {
      enable = true;
      package = emacs-package;
    };

    # Emacs server, new window with `emacsclient -c`
    services.emacs = {
      enable = true;
      package = emacs-package;
      client.enable = true;
    };
  };
}
