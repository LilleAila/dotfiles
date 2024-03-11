{ config, pkgs, inputs, lib, ... }:

{
	# TODO: Move this to a nix-shell in 1T-oppgaver
	home.packages = with pkgs; [
		python311Packages.pygments
		pandoc
		texliveFull
		zathura
	];
}
