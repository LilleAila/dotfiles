{
  config,
  pkgs,
  inputs,
  lib,
  keys,
  ...
}:
{
  config = lib.mkIf config.settings.terminal.utils.enable {
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
        pu = "pull";
        pr = "pull --rebase";
        pp = "!git pull --rebase && git push";
        co = "checkout";
        cm = "commit";
        c = "commit -m";
        a = "add";
        aa = "add -A";
        wc = "whatchanged";
        d = "diff";
        fu = "fetch upstream";
        fu-shallow = "fetch --depth=1 upstream";
        cl = "clone";
        cl-shallow = "clone --depth=1";
      };
      ignores = [
        ".direnv"
        "result"
      ];
    };

    home.packages = [ pkgs.git-crypt ];

    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme =
          let
            c = config.colorScheme.palette;
          in
          {
            activeBorderColor = [
              "#${c.base07}"
              "bold"
            ];
            inactiveBorderColor = [ "#${c.base04}" ];
            searchingActiveBorderColor = [
              "#${c.base02}"
              "bold"
            ];
            optionsTextColor = [ "#${c.base06}" ];
            selectedLineBgColor = [ "#${c.base03}" ];
            cherryPickedCommitBgColor = [ "#${c.base02}" ];
            cherryPickedCommitFgColor = [ "#${c.base03}" ];
            unstagedChangesColor = [ "#${c.base08}" ];
            defaultFgColor = [ "#${c.base05}" ];
          };
      };
    };

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

    settings.persist.home.cache_files = [ "gpg-key.asc" ];
    settings.persist.home.cache = [
      ".gnupg"
      ".local/state/lazygit"
    ];
  };
}
