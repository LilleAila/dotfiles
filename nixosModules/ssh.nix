{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config =
    lib.mkIf (config.settings.ssh.enable)
    (lib.mkMerge [
      {
        services.openssh.enable = true;
        # TODO: Change to authorized keys-file with SOPS
        users.users."${config.settings.user.name}".openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8kaSCUCHrIhpwp5tU6vWeQ/dFX+f3/B7XU31Kl51vG olai.solsvik@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5Z52ibKQO2mugbjo8x4+EvWFSCf+rFg8cOd9Zl7Xj2 olai.solsvik@gmail.com legion"
        ];
      }
      /*
      # Store SSH keys with SOPS (not really necessary because publickey)
      (lib.mkIf (config.settings.sops.enable) {
      	sops.secrets.ssh-m1pro14 = {};
      	users.users."${config.settings.user.name}".openssh.authorizedKeys.keyFiles = [
      		"${config.sops.secrets.ssh-m1pro14.path}"
      	];
      })
      */
    ]);
}
