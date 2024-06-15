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

    sops.age.generateKey = false;
    sops.age.keyFile = "/persist/home/${config.settings.user.name}/.config/sops/age/keys.txt";
    # settings.persist.home.files = [".config/sops/age/keys.txt"];
    settings.persist.home.directories = [".config/sops/age"];

    # This is the hashed password, from `echo "password" | mkpasswd -s`
    # Also delete from history with history -d <id>
    sops.secrets.password = {
      neededForUsers = true;
    };
    users.users."${config.settings.user.name}".hashedPasswordFile = config.sops.secrets.password.path;
  };
}
