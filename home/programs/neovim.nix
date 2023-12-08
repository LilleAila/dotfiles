{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		nodePackages.neovim
		python311Packages.pynvim
	];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
