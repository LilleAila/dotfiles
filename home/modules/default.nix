{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./shell
    ./desktop
    ./other

    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-colors.homeManagerModules.default
  ];

  # FIXME ? not set to true by default?
  options.settings.sops.enable = lib.mkDisableOption "sops";

  config = lib.mkMerge [
    (lib.mkIf config.settings.sops.enable {
      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../secrets/secrets.yaml;
      };

      # NOTE: when setting up a new machine, `nixos-rebuild switch` has to be run twice.
      # The first time, this file is written, but the 'setupSecretsForUsers' activation script failes
      # Then, it has to be run a second time to decrypt all the SOPS secrets.
      # FIXME: put this key into the install media or something instead of using secrets (or do something like git-crypt?)
      home.file.".config/sops/age/keys.txt".text = inputs.secrets.sops.age-key;
    })
  ];
}
