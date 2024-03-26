{ config, pkgs, inputs, lib, ... }:

let
	inherit (lib) mkOption types;
in
{
	options.settings.terminal = {
		zsh.enable = mkOption {
			type = types.bool;
			default = false;
		};
		zsh.theme = mkOption {
			type = types.str;
			default = "nanotech";
		};
	};

	config = lib.mkIf (config.settings.terminal.zsh.enable) {
		programs.zsh = {
			enable = true;
			enableCompletion = true;
			enableAutosuggestions = true;
			syntaxHighlighting.enable = true;
			oh-my-zsh = {
				enable = true;
				# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
				theme = config.settings.terminal.zsh.theme;
			};
			initExtra = ''
				ex = () {
					if [ -f $1 ] ; then
						case $1 in
							*.tar.bz2) tar xjf $1 ;;
							*.tar.gz)  tar xzf $1 ;;
							*.bz2)     bunzip2 $1 ;;
							*.rar)     ${pkgs.unrar-wrapper}/bin/unrar x $1 ;;
							*.gz)      gunzip $1 ;;
							*.tar)     tar xf $1 ;;
							*.tbz2)    tar xjf $1 ;;
							*.tgz)     tar xzf $1 ;;
							*.zip)     ${pkgs.unzip}/bin/unzip $1 ;;
							*.Z)       uncompress $1 ;;
							*.7z)      ${pkgs.p7zip}/bin/7z x $1 ;;
							*.deb)     ar x $1 ;;
							*.tar.xz)  tar xf $1 ;;
							*.tar.zst) unzstd $1 ;;
							*)         echo "Could not extract $1"
						esac
					else
						echo "$1 is not a valid file"
					fi
			}

			${pkgs.leaf}/bin/leaf
			'';
			/*
				Fastest to slowest
				${pkgs.screenfetch}/bin/screenfetch
				${pkgs.neofetch}/bin/neofetch
				${pkgs.fastfetch}/bin/fastfetch
				${pkgs.disfetch}/bin/disfetch
				${pkgs.owofetch}/bin/owofetch
				${pkgs.inxi}/bin/inxi
				${pkgs.nitch}/bin/nitch
				${pkgs.bunnyfetch}/bin/bunnyfetch
				${pkgs.yafetch}/bin/yafetch
				${pkgs.afetch}/bin/afetch
				cat /etc/os-release
				${pkgs.leaf}/bin/leaf
			*/
		};
	};
}
