{ self, lib, ... }:
{
  flake.modules.homeManager.themes =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings = {
        gtk.enable = lib.mkEnableOption "gtk";
        cursor.package = lib.mkOption { type = lib.types.package; };
        cursor.name = lib.mkOption { type = lib.types.str; };
        cursor.size = lib.mkOption { type = lib.types.int; };
      };

      config = lib.mkMerge [
        (lib.mkIf config.settings.gtk.enable (
          let
            gtkCss = import ./_gtk-theme2.nix {
              inherit (self) colorScheme;
              inherit self lib;
            };
          in
          {
            gtk = {
              enable = true;
              # Tested schene with `nix-shell -p awf --run awf-gtk3`
              # Custom css file for adwaita is a lot better than using a custom theme
              # theme.package = import ./_gtk-theme.nix { inherit pkgs; } { scheme = self.colorScheme; };
              # theme.name = "${self.colorScheme.slug}";
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
    };
}
