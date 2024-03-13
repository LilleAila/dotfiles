{ config, pkgs, inputs, lib, ... }:

{
	imports = [
		./zsh.nix
		./terminal.nix
		./neovim.nix
		./lf.nix
		./git.nix
	];
}
