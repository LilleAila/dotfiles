{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = lib.mkIf (config.settings.terminal.utils.enable) {
    programs.git = {
      enable = true;
      userName = "LilleAila";
      userEmail = inputs.secrets.email;
      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgSign = true;
        gpg.program = "${lib.getExe config.programs.gpg.package}";
        user.signingKey = inputs.secrets.gpg.id;
      };
      aliases = {
        p = "push";
        pp = "pull";
        pr = "pull --rebase";
        co = "checkout";
        cm = "commit";
        c = "commit -m";
        aa = "add -A";
      };
      ignores = [
        ".direnv"
        "result"
      ];
    };

    # TODO: somehow syncronise GPG (and maybe SSH too) keys between computers (secrets with sops or private repo?)
    # Idk if this should be configured in system or user..
    programs.gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.gnupg";
      mutableKeys = true; # FIXME ? it might be better to keep mutable, idk
      # package = pkgs.gnupg;
      publicKeys = [
        {
          text = inputs.secrets.gpg.public;
          trust = "ultimate";
        }
      ];
    };

    services.gpg-agent = {
      enable = true;
      # Doesn't look the best, but it works /shrug
      pinentryPackage = pkgs.pinentry-qt;
    };

    sops.secrets."gpg/primary".path = "${config.home.homeDirectory}/.gnupg/private-keys-v1.d/${inputs.secrets.gpg.primary.name}.key";
    sops.secrets."gpg/subkey".path = "${config.home.homeDirectory}/.gnupg/private-keys-v1.d/${inputs.secrets.gpg.subkey.name}.key";
  };
}
