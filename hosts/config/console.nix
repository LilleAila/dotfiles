{ config, pkgs, inputs, lib, ... }:

{
	options.settings.console = {
		font = lib.mkOption {
			type = lib.types.str;
			default = "ter-u32n";
		};
		keyMap = lib.mkOption {
			type = lib.types.str;
			default = "no";
		};
	};

	config = with config.settings.console; {
		fonts.packages = with pkgs; [ terminus_font ];
		console = {
			packages = with pkgs; [ terminus_font ];
			font = font;
			keyMap = keyMap;
		};
	};
}
