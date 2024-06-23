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
    gtk.enable = lib.mkEnableOption "gtk";
    cursor.package = lib.mkOption {type = lib.types.package;};
    cursor.name = lib.mkOption {type = lib.types.str;};
    cursor.size = lib.mkOption {type = lib.types.int;};
  };

  imports = [
    ./qt.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf (config.settings.gtk.enable) {
      gtk = {
        enable = true;
        # Tested schene with `nix-shell -p awf --run awf-gtk3`
        theme.package = import ./gtk-theme.nix {inherit pkgs;} {scheme = config.colorScheme;};
        theme.name = "${config.colorScheme.slug}";
        iconTheme.package = pkgs.papirus-icon-theme;
        iconTheme.name = "Papirus-Dark";
      };
    })
    (lib.mkIf (config.settings.wm.hyprland.enable) {
      home.pointerCursor = {
        package = config.settings.cursor.package;
        name = config.settings.cursor.name;
        size = config.settings.cursor.size;
        gtk.enable = true;
      };
      # wayland.windowManager.hyprland.settings = {
      #   exec-once = [
      #     "hyprctl setcursor \"${config.settings.cursor.name}\" ${toString config.settings.cursor.size} &"
      #   ];
      # };
    })
  ];
}
