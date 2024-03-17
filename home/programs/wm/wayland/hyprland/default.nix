{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./binds.nix
		./settings.nix
		./screenshots.nix
	];

	options.settings.wm.hyprland = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
		useLegacyRenderer = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.wm.hyprland.enable) {
			# Random dependencies and stuff
			home.packages = with pkgs; [
				rofi-wayland
				dolphin
				libnotify
				avizo
				pamixer
				playerctl
				brightnessctl
				qalculate-gtk
			];

			# TODO: cursor does not work properly on m1pro14
			# TODO: legacyRenderer override only for m1pro14
			# TODO: enable display under notch to show bar
			wayland.windowManager.hyprland = {
				enable = true;
				# package = (inputs.hyprland.packages."${pkgs.system}".hyprland.override { legacyRenderer = true; });
				systemd.enable = true;
				xwayland.enable = true;
			};
		})
		# There is probably a more clean way to do this
		(lib.mkIf (config.settings.wm.hyprland.useLegacyRenderer) {
			wayland.windowManager.hyprland.package = (inputs.hyprland.packages."${pkgs.system}".hyprland.override { legacyRenderer = true; });
		})
		(lib.mkIf (!config.settings.wm.hyprland.useLegacyRenderer) {
			wayland.windowManager.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
		})
	];
}
