# It no no work :(
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  options.settings.wm.espanso.enable = lib.mkEnableOption "espanso";

  config = lib.mkIf config.settings.wm.espanso.enable {
    services.espanso = {
      enable = true;
      package = pkgs.espanso.override {
        waylandSupport = true;
        x11Support = false;
      };
      configs.default = {
        backend = "inject";
        evdev_modifier_delay = 10;
        inject_delay = 1;
        keyboard_layout.layout = "no";
        preserve_clipboard = true;
        search_shortcut = "ALT+Space"; # TODO: https://espanso.org/docs/configuration/options/#customizing-the-search-bar
      };

      matches.base.matches = [
        {
          trigger = ";test";
          replace = "Hello, Worl?";
        }
      ];
    };
  };
}
