{ config, pkgs, lib, inputs, ... }:

{
	# TODO: rewrite in ags
	services.mako = {
		enable = true;
		backgroundColor = "#${config.colorScheme.palette.base01}";
		borderColor = "#${config.colorScheme.palette.base0E}";
		borderRadius = 5;
		borderSize = 2;
		textColor = "#${config.colorScheme.palette.base04}";
		layer = "overlay";
	};
}
