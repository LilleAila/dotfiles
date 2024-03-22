{ config, pkgs, inputs, lib, ... }:

{
	options.settings.user = {
		name = lib.mkOption {
			type = lib.types.str;
		};
		desc = lib.mkOption {
			type = lib.types.str;
			default = config.settings.user.name;
			description = "User description";
		};
		shell = lib.mkOption {
			type = lib.types.package;
			default = pkgs.zsh;
		};
	};

	config = with config.settings.user; {
		users.users."${name}" = {
			isNormalUser = true;
			description = desc;
			extraGroups = [ "wheel" ];
			packages = with pkgs; [];
			shell = shell;
			initialPassword = "";
		};
	};
}
