{ config, pkgs, inputs, lib, ... }:

{
	# programs.texlive = {
	# 	enable = true;
	# 	# packageSet = pkgs.texliveFull;
	# };
	home.packages = with pkgs; [
		python311Packages.pygments
		pandoc
		texliveFull
		zathura
	];
}
