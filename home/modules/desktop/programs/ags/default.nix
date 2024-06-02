{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  options.settings.wm.ags.enable = lib.mkEnableOption "ags";

  config = lib.mkIf (config.settings.wm.ags.enable) {
    programs.ags = {
      enable = true;

      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

    home.file.".config/ags".source = inputs.ags-config.packages.${pkgs.system}.default.override {
      colorScheme = config.colorScheme;
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "ags"
      ];
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
