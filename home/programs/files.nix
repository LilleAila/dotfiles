{ config, pkgs, inputs, lib, ... }:

{
	options.settings.files = {
		nemo.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};

		thunar.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.files.nemo.enable) {
			home.packages = with pkgs; [
				cinnamon.nemo
			];
		})
		(lib.mkIf (config.settings.files.thunar.enable) {
			home.packages = with pkgs; [
				(xfce.thunar.override {
					thunarPlugins = with xfce; [
						thunar-archive-plugin
						thunar-volman
						thunar-media-tags-plugin
					];
				})
			];
		 })
	];
}
