{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./monitors.nix
		./hyprland
		./hyprlock.nix
		./hypridle.nix
		./hyprpaper.nix
		./general.nix
		./mako.nix
		./avizo.nix
		./wlogout.nix
	];
}
