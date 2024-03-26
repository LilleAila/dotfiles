{ config, pkgs, inputs, lib, ... }:

{
	imports = [
		./zsh.nix
		./fish.nix
		./terminal.nix
		./neovim.nix
		./lf.nix
		./git.nix
	];
}
