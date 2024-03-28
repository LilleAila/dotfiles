{ config, pkgs, inputs, lib, ... }:

{
	options.settings.terminal.neovim.enable = lib.mkEnableOption "neovim";

	config = lib.mkIf (config.settings.terminal.neovim.enable)
		(lib.mkMerge [
			{
				programs.neovim = {
					enable = true;
					# package = inputs.nixvim-config.packages."${pkgs.system}".nixvim;
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

				# home.packages = [ inputs.nixvim-config.config.packages."${pkgs.system}".nvim ];

				home.sessionVariables = {
					EDITOR = "nvim";
				};
			}
			(lib.mkIf (config.settings.terminal.emulator.enable) {
				xdg.desktopEntries.nvim = {
					name = "Neovim";
					genericName = "Text Editor";
					icon = "nvim";
					exec = "${config.settings.terminal.emulator.exec} ${lib.getExe config.programs.neovim.package} %f";
				};
				xdg.mimeApps.defaultApplications = {
					"text/plain" = "nvim.desktop";
					"application/x-shellscript" = "nvim.desktop";
				};
			})
		]);
}
