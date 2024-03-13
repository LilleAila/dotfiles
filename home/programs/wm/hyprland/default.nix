{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hyprland.nix
		./hypridle.nix
		./general.nix
		./swaylock.nix
		./mako.nix
		./avizo.nix
		./wlogout.nix
		# ./ags.nix
	];
}
