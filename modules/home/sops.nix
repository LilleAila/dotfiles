{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.homeManager.sops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      options.settings.sops.enable = self.lib.mkDisableOption "sops";

      config = lib.mkIf config.settings.sops.enable {
        sops = {
          age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
          defaultSopsFile = ../../secrets/secrets.yaml;
        };

        home.file.".config/sops/age/keys.txt".source = ../../secrets/sops-key.txt;
      };
    };
}
