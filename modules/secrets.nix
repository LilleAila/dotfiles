{
  self,
  lib,
  inputs,
  ...
}:
{
  # FIXME: do this in a better way such that if it fails, the flake will still be usable.
  # Atm i don't think anyone can use this flake because this causes it to fail
  flake.secrets = import ../secrets/secrets.nix;
  flake.keys = import ../secrets/not-so-secrets.nix;

  flake.modules.homeManager.gpg-key = {
    # Needed to decrypt the other secrets
    home.file."gpg-key.asc".source = ../secrets/gpg-key.asc;
  };

  flake.modules.homeManager.sops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      options.settings.sops.enable = self.lib.mkDisableOption "sops";

      config = lib.mkIf config.settings.sops.enable {
        sops = {
          age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
          defaultSopsFile = ../secrets/secrets.yaml;
        };
      };
    };

  flake.modules.darwin.sops =
    { config, ... }:
    {
      options.settings.sops.enable = self.lib.mkDisableOption "sops";

      config = lib.mkIf config.settings.sops.enable {
        hm.settings.sops.enable = true;
        hm.home.file."Library/Application Support/sops/age/keys.txt".source = ../secrets/sops-key.txt;
      };
    };

  flake.modules.nixos.sops =
    {
      config,
      pkgs,
      ...
    }:
    {
      options.settings.sops.enable = self.lib.mkDisableOption "sops";

      imports = [ inputs.sops-nix.nixosModules.sops ];

      config = lib.mkIf config.settings.sops.enable {
        hm.settings.sops.enable = true;
        hm.home.file.".config/sops/age/keys.txt".source = ../secrets/sops-key.txt;

        sops.defaultSopsFile = ../secrets/secrets.yaml;
        sops.defaultSopsFormat = "yaml";

        # sops.age.keyFile = lib.mkDefault "/etc/sops-key.txt";
        sops.age.keyFile = lib.mkDefault "/${config.hm.home.homeDirectory}/.config/sops/age/keys.txt";
        sops.age.generateKey = false;

        # This is the hashed password, from `echo "password" | mkpasswd -s`
        # Also delete from history with history -d <id>
        sops.secrets.password = {
          neededForUsers = true;
        };
        user.hashedPasswordFile = config.sops.secrets.password.path;
      };
    };
}
