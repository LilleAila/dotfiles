{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  nix-colors-lib = inputs.nix-colors.lib.contrib {inherit pkgs;};
in {
  options.settings = {
    qt.enable = lib.mkEnableOption "qt";
    gtk.enable = lib.mkEnableOption "gtk";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.qt.enable) {
      qt = {
        enable = true;
        # platformTheme = "gtk";
        # style.name = "adwaita-dark";
        # style.package = pkgs.adwaita-qt;
        platformTheme = "gtk";
        style = {
          name = "gtk2";
          package = pkgs.qt6Packages.qt6gtk2;
        };
      };
    })
    (lib.mkIf (config.settings.gtk.enable) {
      gtk = {
        enable = true;
        cursorTheme.package = pkgs.bibata-cursors;
        cursorTheme.name = "Bibata-Modern-Ice";
        # Tested schene with `nix-shell -p awf --run awf-gtk3`
        theme.package = nix-colors-lib.gtkThemeFromScheme {
          scheme = config.colorScheme;
        };
        theme.name = "${config.colorScheme.slug}";
        iconTheme.package = pkgs.papirus-icon-theme;
        iconTheme.name = "Papirus-Dark";
      };
    })
    (lib.mkIf (config.settings.wm.hyprland.enable) {
      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      wayland.windowManager.hyprland.settings.exec-once = [
        "hyprctl setcursor \"Bibata-Modern-Ice\" &"
      ];
    })
  ];
}
