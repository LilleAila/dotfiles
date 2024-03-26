{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./binds.nix
		./settings.nix
		./screenshots.nix
	];

	options.settings.wm.hyprland = {
		enable = lib.mkEnableOption "hyprland";
		useLegacyRenderer = lib.mkEnableOption "legacyRenderer";
	};

	config = lib.mkMerge [
		(lib.mkIf (config.settings.wm.hyprland.enable) {
			# Random dependencies and stuff
			home.packages = with pkgs; [
				rofi-wayland
				libnotify
				avizo
				pamixer
				playerctl
				brightnessctl
				qalculate-gtk
			];

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
