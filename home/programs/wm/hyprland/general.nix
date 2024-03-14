{ config, pkgs, lib, inputs, ... }:

{
	qt = {
		enable = true;
		platformTheme = "gtk";
		style.name = "adwaita-dark";
		style.package = pkgs.adwaita-qt;
	};

	gtk = {
		enable = true;
		cursorTheme.package = pkgs.bibata-cursors;
		cursorTheme.name = "Bibata-Modern-Ice";
		theme.package = pkgs.adw-gtk3;
		theme.name = "adw-gtk3-dark";
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

	home.file.".config/swappy/config".text = ''
	[Default]
	save_dir=$HOME/Screenshots/Edited
	save_filename_format=%Y-%m-%d,%H:%M:%S.png
	show_panel=true
	# early_exit=true
	'';
}
