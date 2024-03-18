{ config, pkgs, inputs, lib, ... }:

{
	# NOTE: This is not the same options.settings as in home; All options are completely separate
	options.settings.greeter.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
	};

	config = lib.mkIf (config.settings.greeter.enable) {
		services.greetd = {
			enable = true;
			settings = {
				default_session = {
					command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
				};
			};
			vt = 2;
		};
	};
}
