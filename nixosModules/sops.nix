{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.sops.enable = lib.mkEnableOption "sops";

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = lib.mkIf (config.settings.sops.enable) {
    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    environment.etc."sops-key.txt".source = ../secrets/sops-key.txt;
    sops.age.keyFile = lib.mkDefault "/etc/sops-key.txt";
    sops.age.generateKey = false;

    # This is the hashed password, from `echo "password" | mkpasswd -s`
    # Also delete from history with history -d <id>
    sops.secrets.password = {
      neededForUsers = true;
    };
    users.users."${config.settings.user.name}".hashedPasswordFile = config.sops.secrets.password.path;
  };
}
