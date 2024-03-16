{ config, pkgs, inputs, lib, ... }:

{	
	home = {
		username = "olai";
		homeDirectory = "/home/olai";
		stateVersion = "23.11"; # Changed from stable 23.05
	};

  imports = [
		inputs.nix-colors.homeManagerModules.default
		./programs/shell

		./programs/browser.nix
		./programs/discord.nix
		./programs/texlive.nix
		./programs/emacs

		# ./programs/wallpaper/wallpaper.nix
		./programs/wm/hyprland
		./programs/wm/ags
  ];

	settings = {
		wallpaper = ./wallpapers/wall13.jpg;
		monitors = [
			{
				name = "eDP-1";
				width = 3024;
				height = 1890;
				refreshRate = 60;
				x = 0;
				y = 0;
				scale = 2;
				enabled = true;
			}
			{
				name = "HDMI-A-1";
				width = 2560;
				height = 1440;
				refreshRate = 144;
				x = -524;
				y = -1440;
				scale = 1;
				enabled = true;
			}
		];
	};

	# https://github.com/tinted-theming/base16-schemes/
	# colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
	colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

	# nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		# "discord"
		"geogebra6"
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

		geogebra6
  ];

	programs.mpv = {
		enable = true;
	};
}
