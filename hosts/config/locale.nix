{ config, pkgs, inputs, lib, ... }:

{
	options.settings.locale = {
		main = lib.mkOption {
			type = lib.types.str;
			default = "en_US.UTF-8";
		};
		other = lib.mkOption {
			type = lib.types.str;
			default = config.settings.locale.main;
		};
		timeZone = lib.mkOption {
			type = lib.types.str;
			default = "Europe/Oslo";
		};
	};

	config = with config.settings.locale; {
		i18n.defaultLocale = "${main}";
		i18n.extraLocaleSettings = {
			LC_ADDRESS = "${other}";
			LC_IDENTIFICATION = "${other}";
			LC_MEASUREMENT = "${other}";
			LC_MONETARY = "${other}";
			LC_NAME = "${other}";
			LC_NUMERIC = "${other}";
			LC_PAPER = "${other}";
			LC_TELEPHONE = "${other}";
			LC_TIME = "${other}";
		};
		time.timeZone = timeZone;
	};
}
