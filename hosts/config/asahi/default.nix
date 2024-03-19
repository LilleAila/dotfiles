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
		services.udev.extraRules = ''
KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80", ATTR{charge_control_start_threshold}="60"
		'';
	};
}
