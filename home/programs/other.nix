{ config, pkgs, inputs, lib, ... }:

{
	options.settings = {
		imageviewer.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
		other.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.imageviewer.enable) {
			# Image viewers:
			# lxqt.lximage-qt (does not get themed bc QT and not GTK)
			# loupe (not the best UI)
			# feh (very minimal)
			# oculante (blurry and no theme)
			# cinnamon.pix (YES)
			# swayimg (good but has to be configed)
			# vimiv-qt (VIM but no theme)
			home.packages = [ pkgs.cinnamon.pix ];
			xdg.desktopEntries.pix = {
				name = "Pix";
				genericName = "Image viewer";
				icon = "pix";
				exec = "${lib.getExe' pkgs.cinnamon.pix "pix"} %f";
			};
			xdg.mimeApps.defaultApplications = {
				"image/png" = "pix.desktop";
				"image/jpg" = "pix.desktop";
				"image/jpeg" = "pix.desktop";
			};
		})
		(lib.mkIf (config.settings.other.enable) {
			services.blueman-applet.enable = true;
			services.network-manager-applet.enable = true;

			xdg.mimeApps.enable = true;
			# https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
			xdg.mimeApps.defaultApplications = {
				"application/pdf" = "zathura.desktop";
				"video/png" = "mpv.desktop";
				"video/jpg" = "mpv.desktop";
				"video/mp4" = "mpv.desktop";
				"video/mov" = "mpv.desktop";
				"video/webm" = "mpv.desktop";
				"video/ogg" = "mpv.desktop";
			};
		 })
	];
}
