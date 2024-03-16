{ config, pkgs, lib, inputs, ... }:

# let
# 	wallpaper = ./wall1.png;
# in
{
	options = {
		wallpaper = lib.mkOption {
			default = ./wall1.png;
			type = lib.types.path;
			description = ''
			Path to your wallpaper
			'';
		};
	};

	imports = [
		inputs.hyprpaper.homeManagerModules.hyprpaper
	];

	config = {
		services.hyprpaper = {
			enable = true;
			splash = true;
			splash_offset = 2.0;
			ipc = true;

			preloads = [
				"${config.wallpaper}"
			];
			wallpapers = [
				", ${config.wallpaper}"
			];
		};
	};
}
