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
      userEmail = "olai" + ".sols" + "vik@gm" + "ail.co" + "m";
      extraConfig = {
        init.defaultBranch = "main";
      };
      aliases = {
        pu = "push";
        co = "checkout";
        cm = "commit";
      };
    };
  };
}
