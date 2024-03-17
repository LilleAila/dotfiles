{ config, pkgs, lib, inputs, ... }:

let
	nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{
	# This is very cool, but i prefer using a less minimal photo instead, maybe generate scheme from wallpaper at some point
	# home.file."test-wallpaper.png".source = nix-colors-lib.nixWallpaperFromScheme {
	# 	scheme = config.colorScheme;
	# 	width = 1920;
	# 	height = 1080;
	# 	logoScale = 5.0;
	# };

	qt = {
		enable = true;
		platformTheme = "gtk";
		style.name = "adwaita-dark";
		style.package = pkgs.adwaita-qt;
	};

	# TODO: Make the GTK theme look good. maybe make a copy of the derivation and tweak it
	gtk = {
		enable = true;
		cursorTheme.package = pkgs.bibata-cursors;
		cursorTheme.name = "Bibata-Modern-Ice";
		# theme.package = pkgs.adw-gtk3;
		# theme.name = "adw-gtk3-dark";
		theme.package = nix-colors-lib.gtkThemeFromScheme {
			scheme = config.colorScheme;
		};
		# theme.package = (import ./gtk-theme.nix {
		# 	inherit pkgs;
		# } {
		# 	scheme = config.colorScheme;
		# });
		theme.name = "${config.colorScheme.slug}";
		iconTheme.package = pkgs.papirus-icon-theme;
		iconTheme.name = "Papirus-Dark";
	};

	services.blueman-applet.enable = true;
	services.network-manager-applet.enable = true;

	xdg.mimeApps.defaultApplications = {
		"text/plain" = [ "neovide.desktop" ];
		"application/pdf" = [ "zathura.desktop" ];
		"image/*" = [ "sxiv.desktop" ];
		"video/png" = [ "mpv.desktop" ];
		"video/jpg" = [ "mpv.desktop" ];
		"video/*" = [ "mpv.desktop" ];
	};

	# Configure swapy (simple screenshot annotation)
	home.file.".config/swappy/config".text = ''
	[Default]
	save_dir=$HOME/Screenshots/Edited
	save_filename_format=%Y-%m-%d,%H:%M:%S.png
	show_panel=true
	# early_exit=true
	'';
}
