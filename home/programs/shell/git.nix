{ config, pkgs, inputs, lib, ... }:

{
	config = lib.mkIf (config.settings.terminal.zsh.utils.enable) {
		programs.git = {
			enable = true;
			userName = "LilleAila";
			# TODO: use secrets with sops instead of whatever this is:
			userEmail = "olai" + ".sols" + "vik@gm" + "ail.co" + "m";
			aliases = {
				pu = "push";
				co = "checkout";
				cm = "commit";
			};
			# extraConfig = {
			# 	credential.helper = "store"; # I should probably switch to ssh # I SWITCHED TO SSH!!!
			# };
		};
	};
}
