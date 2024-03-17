{ config, pkgs, inputs, lib, ... }:

{
	options.settings.files = {
		nemo.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};

		thunar.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.files.nemo.enable) {
			home.packages = with pkgs; [
				(cinnamon.nemo-with-extensions.override {
					extensions = with cinnamon; [
						nemo-fileroller # archives
					];
				})
			];
			# nix-shell -p gnome.dconf-editor --run dconf-editor
			# taken from arch wiki, but doesn't work :(
			dconf.settings = {
				"org/cinnamon/desktop/default-applications/terminal" = {
					exec = "kitty";
				};
				"org/nemo/desktop" = {
					show-desktop-icons = false;
				};
				# General config
				"org/nemo/preferences" = {
					date-font-choice = "auto-mono";
					default-folder-viewer = "list-view";
					"inherit-folder-viewer" = true;
					ignore-view-metadata = true;
					click-policy = "double";
					quick-renames-with-pause-in-between = false; # double-click name to rename
					click-double-parent-folder = true; # double-click empty space
					never-queue-file-ops = false;
					start-with-dual-pane = false;
					confirm-trash = true;
					enable-delete = true;
					date-format = "iso";
					show-full-path-titles = false;
					show-image-thumbnails = "local-only";

					show-compact-view-icon-toolbar = false;
					show-computer-icon-toolbar = true;
					show-edit-icon-toolbar = false;
					show-home-icon-toolbar = true;
					show-icon-view-icon-toolbar = true;
					show-list-view-icon-toolbar = true;
					show-new-folder-icon-toolbar = true;
					show-next-icon-toolbar = true;
					show-previous-icon-toolbar = true;
					show-reload-icon-toolbar = true;
					show-search-icon-toolbar = true;
					show-up-icon-toolbar = true;
				};
				# Context menus:
				"org/nemo/preferences/menu-config" = {
					background-menu-create-new-folder = true;
					background-menu-open-as-root = true;
					background-menu-open-in-terminal = false;
					background-menu-paste = true;
					background-menu-properties = true;
					background-menu-scripts = true;
					background-menu-show-hidden-files = true;

					desktop-menu-customize = true;

					iconview-menu-arrange-items = true;
					iconview-menu-organize-by-name = true;

					selection-menu-copy = true;
					selection-menu-copy-to = false;
					selection-menu-cut = true;
					selection-menu-duplicate = true;
					selection-manu-favorite = true;
					selection-menu-make-link = false;
					selection-menu-move-to = false;
					selection-menu-move-to-trash = true;
					selection-menu-open = true;
					selection-menu-open-as-root = true;
					selection-menu-open-in-new-tab = true;
					selection-menu-open-in-new-window = true;
					selection-menu-open-in-terminal = false;
					selection-menu-paste = true;
					selection-menu-pin = true;
					selection-menu-properties = true;
					selection-menu-rename = true;
					selection-menu-scripts = true;
				};
			};
		})
		(lib.mkIf (config.settings.files.thunar.enable) {
			home.packages = with pkgs; [
				(xfce.thunar.override {
					thunarPlugins = with xfce; [
						thunar-archive-plugin
						thunar-volman # volumes
						thunar-media-tags-plugin
					];
				})
				xfce.exo
				xfce.catfish
# Wiki says to enable in system, but this looks like it works the same:
# Only difference is system adds it to dbus...
				xfce.tumbler
				webp-pixbuf-loader
				poppler
				ffmpegthumbnailer
				freetype
				libgsf
				gnome.totem
				evince
				gnome-epub-thumbnailer
				mcomix
				f3d
			];

			# TODO: make terminal emulator a string in config.settings that will be used everywhere
			# TODO: add actions from here: https://docs.xfce.org/xfce/thunar/custom-actions#adding_a_custom_action to ~/.config/Thunar/uca.xml
			home.file.".config/xfce4/helpers.rc".source = pkgs.writeText "helpers.rc" ''
			TerminalEmulator=kitty
			'';

			systemd.user.services.thunar = {
				Unit = {
					Description = "Thunar file manager daemon";
					PartOf = [ "graphical-session.target" ];
				};

				Service = {
					ExecStart = "${pkgs.xfce.thunar}/bin/thunar --daemon";
					Restart = "on-failure";
				};

				Install.WantedBy = [ "graphical-session.target" ];
			};
		 })
	];
}
