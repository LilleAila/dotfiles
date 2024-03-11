{ config, pkgs, lib, inputs, ... }:

{
	# TODO: switch to hyprlock + hypridle
	programs.swaylock = {
		enable = true;
		package = pkgs.swaylock-effects;
		settings = {
			screenshot = true;
			clock = true;
			indicator-radius = 100;
			indicator-thickness = 7;
			effect-blur = "7x5";
			effect-vignette = "0.5:0.5";
			ring-color = "${config.colorScheme.palette.base06}";
			key-hl-color = "${config.colorScheme.palette.base0B}";
			line-color = "00000000";
			inside-color = "${config.colorScheme.palette.base00}88";
			separator-color = "00000000";
			grace = 2;
			fade-in = 0.2;
		};
	};
}
