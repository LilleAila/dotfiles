{ config, pkgs, inputs, lib, ... }:

{
	options.settings.terminal = {
		kitty.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
		wezterm.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
		alacritty.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.terminal.kitty.enable) {
			home.packages = [ pkgs.nerdfonts ];
			programs.kitty = {
				enable = true;
				package = pkgs.kitty;
				font = {
					name = "JetBrains Mono Nerd Font";
					size = 10;
					package = pkgs.nerdfonts;
				};
				shellIntegration.enableZshIntegration = true;
				settings = with config.colorScheme.palette; {
					scrollback_lines = 1000;
					placement_strategy = "center";
					allow_remote_control = "yes";
					enable_audio_bell = "no";
					copy_on_select = "clipboard";
					background_opacity = "0.9";

					foreground = "#${base06}";
					background = "#${base00}";
					selection_foreground = "#${base05}";
					selection_background = "#${base02}";
					cursor = "#${base06}";
					cursor_text_color = "#${base00}";
					# Black
					color0 = "#${base00}";
					color8 = "#${base04}";
					# Red
					color1 = "#${base08}";
					color9 = "#${base08}";
					# Green
					color2 = "#${base0B}";
					color10 = "#${base0B}";
					# Yellow
					color3 = "#${base0A}";
					color11 = "#${base0A}";
					# Blue
					color4 = "#${base0D}";
					color12 = "#${base0D}";
					# Magenta
					color5 = "#${base0E}";
					color13 = "#${base0E}";
					# Cyan
					color6 = "#${base0C}";
					color14 = "#${base0C}";
					# White
					color7 = "#${base06}";
					color15 = "#${base06}";
				};
			};
		})
		(lib.mkIf (config.settings.terminal.wezterm.enable) {
			home.packages = [ pkgs.nerdfonts ];
			programs.wezterm = {
				enable = true;
				package = pkgs.wezterm;
				enableZshIntegration = true;
				colorSchemes = {
					base16 = with config.colorScheme.palette; {
						foreground = "#${base06}";
						background = "#${base00}";
						cursor_bg = "#${base06}";
						cursor_fg = "#${base00}";
						cursor_border = "#${base06}";
						selection_fg = "#${base00}";
						selection_bg = "#${base02}";
						scrollbar_thumb = "#${base03}";
						split = "#${base02}";
						compose_cursor = "${base07}";
						ansi = [
							"#${base00}"
							"#${base08}"
							"#${base0B}"
							"#${base0A}"
							"#${base0D}"
							"#${base0E}"
							"#${base0C}"
							"#${base06}"
						];
						brights = [
							"#${base00}"
							"#${base08}"
							"#${base0B}"
							"#${base0A}"
							"#${base0D}"
							"#${base0E}"
							"#${base0C}"
							"#${base06}"
						];
					};
				};
				extraConfig = ''
				local config = {
					enable_wayland = true,
					color_scheme = "base16",
					window_background_opacity = 0.85,
					use_fancy_tab_bar = false,
					font = wezterm.font "JetBrainsMono Nerd Font",
					font_size = 10,
				}
				return config
				'';
			};
		})
		(lib.mkIf (config.settings.terminal.alacritty.enable) {
			home.packages = [ pkgs.nerdfonts ];
			programs.alacritty = {
				enable = true;
				settings.colors = with config.colorScheme.palette; {
					bright = {
						black = "0x${base00}";
						blue = "0x${base0D}";
						cyan = "0x${base0C}";
						green = "0x${base0B}";
						magenta = "0x${base0E}";
						red = "0x${base08}";
						white = "0x${base06}";
						yellow = "0x${base09}";
					};
					cursor = {
						cursor = "0x${base06}";
						text = "0x${base06}";
					};
					normal = {
						black = "0x${base00}";
						blue = "0x${base0D}";
						cyan = "0x${base0C}";
						green = "0x${base0B}";
						magenta = "0x${base0E}";
						red = "0x${base08}";
						white = "0x${base06}";
						yellow = "0x${base0A}";
					};
					primary = {
						background = "0x${base00}";
						foreground = "0x${base06}";
					};
				};
			};
		})
	];
}
