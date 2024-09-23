{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.ssh.enable = lib.mkEnableOption "ssh";
  options.settings.ssh.keys = lib.mkOption' (lib.types.listOf lib.types.str) [ ];

  config = lib.mkIf config.settings.ssh.enable (
    lib.mkMerge [
      {
        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
        users.users."${config.settings.user.name}".openssh.authorizedKeys.keys = config.settings.ssh.keys;
        users.users.root.openssh.authorizedKeys.keys = config.settings.ssh.keys;
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
    ]
  );
}
