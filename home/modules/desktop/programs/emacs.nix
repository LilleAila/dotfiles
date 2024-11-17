{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.emacs.enable = lib.mkEnableOption "emacs";
  options.settings.emacs.package = lib.mkOption {
    type = lib.types.package;
    default = inputs.emacs-config.packages.${pkgs.system}.emacs.override {
      inherit (config) colorScheme;
    };
  };

  config = lib.mkIf config.settings.emacs.enable {
    programs.emacs = {
      enable = true;
      inherit (config.settings.emacs) package;
    };

    # Emacs server, new window with `emacsclient -c`
    services.emacs = {
      enable = true;
      inherit (config.settings.emacs) package;
      client.enable = true;
    };
  };
}
