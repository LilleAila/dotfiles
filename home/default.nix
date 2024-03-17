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
		./programs/zathura.nix

		# ./programs/wallpaper/wallpaper.nix
		./programs/wm/wayland
		./programs/wm/ags
  ];

	# Random other packages
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
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
		
		nurl
  ];

	programs.mpv = {
		enable = true;
	};
}
