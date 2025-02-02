{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.hm.settings.fcitx5.enable {
    # TODO: do the possible configuration here
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "no";
              DefaultIM = "keyboard-no";
            };

            "Groups/0/Items/0" = {
              Name = "keyboard-no";
              Layout = "no";
            };

            "Groups/0/Items/1" = {
              Name = "mozc";
              Layout = "no";
            };

            GroupOrder."0" = "Default";
          };

          addons.classicui.globalSection = with config.hm.colorScheme.palette; {
            TrayOutlineColor = "#${base00}";
            TrayTextColor = "#${base06}";
            Theme = "nix-colors";
            DarkTheme = "nix-colors";

            Font = "Sans 10";
            MenuFont = "Sans 10";
            TrayFont = "Sans Bold 10";
          };
        };
      };
    };
  };
}
