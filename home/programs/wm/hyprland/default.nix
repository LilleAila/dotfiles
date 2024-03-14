{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hyprland.nix
		./hyprlock.nix
		./hypridle.nix
		./hyprpaper.nix
		./general.nix
		# ./swaylock.nix
		./mako.nix
		./avizo.nix
		./wlogout.nix
	];
}
