{ config, pkgs, inputs, lib, ... }:

{
	options.settings.ssh.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
	};

	config = lib.mkIf (config.settings.ssh.enable) {
		services.openssh.enable = true;
		# TODO: Change to authorized keys-file with SOPS
		users.users."${config.settings.user.name}".openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8kaSCUCHrIhpwp5tU6vWeQ/dFX+f3/B7XU31Kl51vG olai.solsvik@gmail.com"
		];
	};
}
