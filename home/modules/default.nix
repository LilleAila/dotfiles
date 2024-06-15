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

      # FIXME: with impermanence, this file is not recognised
      home.file.".config/sops/age/keys.txt".source = ../../secrets/sops-key.txt;
    })
  ];
}
