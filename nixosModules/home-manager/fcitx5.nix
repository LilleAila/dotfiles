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
      };
    };
  };
}
