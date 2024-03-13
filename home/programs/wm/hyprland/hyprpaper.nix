{ config, pkgs, lib, inputs, ... }:

let
	wallpaper = ./wall1.png;
in
{
	imports = [
		inputs.hyprpaper.homeManagerModules.hyprpaper
	];

	# Not needed in hyprland startup because this creates a service
	services.hyprpaper = {
		enable = true;
		splash = true;
		splash_offset = 2.0;
		ipc = true;

		preloads = [
			"${wallpaper}"
		];
		wallpapers = [
			", ${wallpaper}"
		];
	};
}
