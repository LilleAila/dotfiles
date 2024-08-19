{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./shell
    ./desktop
    ./other
    ./school

    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-colors.homeManagerModules.default
  ];

  options.settings.sops.enable = lib.mkDisableOption "sops";

  config = lib.mkMerge [
    (lib.mkIf config.settings.sops.enable {
      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../secrets/secrets.yaml;
      };

      home.file.".config/sops/age/keys.txt".source = ../../secrets/sops-key.txt;
    })
  ];
}
