{ config, pkgs, lib, inputs, ... }:

# let
# 	wallpaper = ./wall1.png;
# in
{
	options.settings = {
		wallpaper = lib.mkOption {
			default = ./wall1.png;
			type = lib.types.path;
			description = ''
			Path to your wallpaper
			'';
		};
		wm.hyprpaper.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	imports = [
		inputs.hyprpaper.homeManagerModules.hyprpaper
	];

	config = lib.mkIf (config.settings.wm.hyprpaper.enable) {
		services.hyprpaper = {
			enable = true;
			splash = true;
			splash_offset = 2.0;
			ipc = true;

			preloads = [
				"${config.settings.wallpaper}"
			];
			wallpapers = [
				", ${config.settings.wallpaper}"
			];
		};
	};
}
