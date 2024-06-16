{
  config,
  pkgs,
  inputs,
  lib,
  keys,
  ...
}: {
  config = lib.mkIf (config.settings.terminal.utils.enable) {
    programs.git = {
      enable = true;
      userName = "LilleAila";
      userEmail = "olai.solsvik@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgSign = true;
        gpg.program = "${lib.getExe config.programs.gpg.package}";
        user.signingKey = keys.gpg.id;
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

    home.packages = [pkgs.git-crypt];

    programs.gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.gnupg";
      mutableKeys = true; # FIXME ? it might be better to keep mutable, idk
      publicKeys = [
        # Remember to run `gpg2 --card-status` so that secret keys work
        {
          text = keys.gpg.public;
          trust = "ultimate";
        }
        {
          text = keys.gpg.other.ildenh;
          trust = "ultimate";
        }
      ];
    };

    settings.persist.home.cache_files = ["gpg-key.asc"];
    settings.persist.home.cache = [".gnupg"];
  };
}
