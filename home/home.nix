{ config, pkgs, inputs, lib, ... }:

{	
	home = {
		username = "olai";
		homeDirectory = "/home/olai";
		stateVersion = "23.11"; # Changed from stable 23.05
	};

  imports = [
		inputs.nix-colors.homeManagerModules.default
  #   ./programs/shell/zsh.nix
  #   ./programs/shell/neovim.nix
	 #  ./programs/shell/terminal.nix
		# ./programs/shell/lf.nix
		# ./programs/shell/git.nix

		./programs/shell

		./programs/browser.nix
		./programs/discord.nix
		./programs/texlive.nix
		./programs/emacs

		# ./programs/wallpaper/wallpaper.nix
		./programs/wm/hyprland
		./programs/wm/ags
  ];

	# https://github.com/tinted-theming/base16-schemes/
	# colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
	colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

	# nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"discord"
	];

  home.packages = with pkgs; [
		gcc
		cmake

		ripgrep
		fd

		nodejs_20
		python311

		dconf

		pavucontrol
  ];

	programs.mpv = {
		enable = true;
	};
}
