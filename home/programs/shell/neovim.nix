{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		extraPackages = with pkgs; [
			# xclip
			wl-clipboard

			nodePackages.neovim
			python311Packages.pynvim

			gcc
		];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
