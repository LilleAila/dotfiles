{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{
  options.settings = {
    gtk.enable = lib.mkEnableOption "gtk";
    cursor.package = lib.mkOption { type = lib.types.package; };
    cursor.name = lib.mkOption { type = lib.types.str; };
    cursor.size = lib.mkOption { type = lib.types.int; };
  };

  imports = [ ./qt.nix ];

  config = lib.mkMerge [
    (lib.mkIf config.settings.gtk.enable (
      let
        gtkCss = import ./gtk-theme2.nix {
          inherit (config) colorScheme;
          inherit lib;
        };
      in
      {
        gtk = {
          enable = true;
          # Tested schene with `nix-shell -p awf --run awf-gtk3`
          # Custom css file for adwaita is a lot better than using a custom theme
          # theme.package = import ./gtk-theme.nix { inherit pkgs; } { scheme = config.colorScheme; };
          # theme.name = "${config.colorScheme.slug}";
          # `gtk.theme` only applies to gtk2 and gtk3
          theme.package = pkgs.adw-gtk3;
          theme.name = "adw-gtk3";
          iconTheme.package = pkgs.papirus-icon-theme;
          iconTheme.name = "Papirus-Dark";
          font.package = config.settings.fonts.sansSerif.package;
          font.name = config.settings.fonts.sansSerif.name;
          font.size = config.settings.fonts.size;
        };

        xdg.configFile."gtk-3.0/gtk.css".text = gtkCss;
        xdg.configFile."gtk-4.0/gtk.css".text = gtkCss;
      }
    ))
  ];
}
