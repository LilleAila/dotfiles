{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  ags-config = inputs.ags-config.packages.${pkgs.system}.default.override {
    inherit (config) colorScheme;
  };
  types = "share/com.github.Aylur.ags/types";
in
{
  options.settings.wm.ags.enable = lib.mkEnableOption "ags";

  config = lib.mkIf config.settings.wm.ags.enable {
    settings.persist.home.cache = [ ".cache/ags" ];

    home.file.".config/ags".source = ags-config;
    home.file.".local/${types}".source = "${pkgs.ags}/${types}";

    wayland.windowManager.hyprland.settings = {
      exec-once = [ "ags" ];
      "$launcher" = "ags -r 'togglePopup(\"applauncher0\")'";
      "$powermenu" = "ags -r 'togglePopup(\"powermenu0\")'";
      bind = [
        ", XF86PowerOff, exec, $powermenu"
        ", XF86Launch1, exec, $powermenu"
        "$mainMod, space, exec, $launcher"
        ", XF86Search, exec, $launcher"
      ];
      layerrule = [
        # "blur, bar*"
        # "ignorezero, bar*"

        "noanim, bar*"
        "noanim, osd*"
        "noanim, powermenu*"
        "noanim, applauncher*"
        "noanim, notifications*"
      ];
    };
  };
}
