{ config, pkgs, ... }:

{
	# home.packages = with pkgs; [
	#   fira-code-nerdfont
	# 	# nerdfonts
	# ];

	programs.kitty = {
		enable = true;
		package = pkgs.kitty;
		font = {
			name = "Fira Code Nerd Font";
			size = 10;
			package = pkgs.fira-code-nerdfont;
		};
		settings = {
			scrollback_lines = 1000;
			placement_strategy = "center";
			allow_remote_control = "yes";
			enable_audio_bell = "no";
			copy_on_select = "clipboard";
			selection_foreground = "none";
			background_opacity = "0.9";
		};

		theme = "Catppuccin-Mocha";
	};
}
