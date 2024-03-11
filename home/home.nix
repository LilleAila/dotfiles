{ config, pkgs, inputs, lib, ... }:

{	
	home = {
		username = "olai";
		homeDirectory = "/home/olai";
		stateVersion = "23.11"; # Changed from stable 23.05
	};

  imports = [
		inputs.nix-colors.homeManagerModules.default
    ./programs/shell/zsh.nix
    ./programs/shell/neovim.nix
	  ./programs/shell/terminal.nix
		./programs/shell/lf.nix

		./programs/browser.nix
		# ./programs/discord.nix
		./programs/texlive.nix
		./programs/emacs

		# ./programs/wallpaper/wallpaper.nix
		./programs/wm/hyprland
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

		webcord-vencord
		# discord
		# (pkgs.discord.override {
		# 	withVencord = true;
		# })

		pavucontrol
  ];

	# TODO: move everything in here to separate files
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
		extraConfig = {
			credential.helper = "store"; # I should probably switch to ssh
		};
	};

	programs.mpv = {
		enable = true;
	};
}
