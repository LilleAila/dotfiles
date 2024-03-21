{ config, pkgs, lib, inputs, ... }:

let
	nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{
	options.settings = {
		qt.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};

		gtk.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.qt.enable) {
			qt = {
				enable = true;
				platformTheme = "gtk";
				style.name = "adwaita-dark";
				style.package = pkgs.adwaita-qt;
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
		{
			# Other stuff idk where to put
			services.blueman-applet.enable = true;
			services.network-manager-applet.enable = true;

			xdg.mimeApps.enable = true;
			xdg.mimeApps.defaultApplications = {
				"application/pdf" = [ "zathura.desktop" ];
				"image/*" = [ "sxiv.desktop" ];
				"video/png" = [ "mpv.desktop" ];
				"video/jpg" = [ "mpv.desktop" ];
				"video/*" = [ "mpv.desktop" ];
			};
		}
	];
}
