{ config, pkgs, ... }:

{	
	home = {
		username = "olai";
		homeDirectory = "/home/olai";
		stateVersion = "23.11"; # Changed from stable 23.05
	};

  imports = [
    ./programs/zsh.nix
    ./programs/neovim.nix
	  ./programs/hyprland.nix
	  ./programs/terminal.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
		gcc
		cmake

		ripgrep
		fd

		nodejs_20
		python311

		neofetch
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

	# Disabled because home manager did not work standalone with flakes
  # programs.home-manager.enable = true;
}
