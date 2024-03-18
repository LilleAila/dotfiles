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

		programs.hyprland.enable = true;

		# Enable OpenGL
		hardware.opengl = {
			enable = true;
			driSupport = true;
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
