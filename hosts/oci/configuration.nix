{ config, lib, pkgs, inputs, globalSettings, ... }:

{
  imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
		../.
  ];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	services.openssh.enable = true;
	users.users.olai.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8kaSCUCHrIhpwp5tU6vWeQ/dFX+f3/B7XU31Kl51vG olai.solsvik@gmail.com"
	];
	
	settings = {
		locale = {
			main = "en_US.UTF-8";
			other = "nb_NO.UTF-8";
			timeZone = "Europe/Oslo";
		};
		user.name = globalSettings.username;
		networking = {
			enable = true;
			hostname = "nixos-oci";
		};
		utils.enable = true;
		console = {
			font = "ter-u32n";
			keyMap = "no";
		};
		sops.enable = true;
	};

  system.stateVersion = "24.05"; # Did you read the comment?
}

