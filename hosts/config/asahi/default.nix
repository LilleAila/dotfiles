{ config, pkgs, inputs, lib, ... }:

{
	options.settings.asahi.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
	};

	config = lib.mkIf (config.settings.asahi.enable) {
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = false;

		hardware.asahi = {
			peripheralFirmwareDirectory = ./firmware;
			useExperimentalGPUDriver = true;
			experimentalGPUInstallMode = "replace";
			withRust = true;
		};
		# TODO: switch to using overlays instead of replacing, so that I can rebuild without `--impure`
		# Overlay has to be made manually, because of infinite loop error from asahi
		# Something like: ( causes full rebuild :( )
		# nixpkgs.overlays = [
		# 	(final: prev: { mesa = final.mesa-asahi-edge; })
		# ];

		programs.hyprland.enable = true; # Wai dis enabel??

		# Enable OpenGL
		hardware.opengl = {
			# package = pkgs.mesa-asahi-edge;
			enable = true;
			driSupport = true;
			# driSupport32Bit = true;
		};

		sound.enable = true;

		swapDevices = [
			{
				device = "/var/lib/swapfile";
				size = 16 * 1024;
			}
		];

		# Idk if this actually works, but it seems to set it to 80/75 for some reason????
		# (ignores actual values, is always either 80/75 og 100/100)
		# TODO: add script to enable / disable fullcharge maybe:
		# echo 100 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold
		# echo 80 | sudo tee /sys/class/power_supply/macsmc-battery/charge_control_end_threshold
		# in home-manager?
		services.udev.extraRules = ''
KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80", ATTR{charge_control_start_threshold}="60"
		'';
	};
}
