{ config, pkgs, inputs, lib, ... }:

{
	options.settings = {
		imageviewer.enable = lib.mkOption {
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
	];
}
