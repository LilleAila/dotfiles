{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.terminal.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf (config.settings.terminal.utils.enable) {
    home.shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      cd = "z";
      open = "xdg-open";
      o = "xdg-open";

      neofetch = "${lib.getExe pkgs.nitch}";

      osbuild = lib.mkDefault "nh os switch";
      nix-collect-garbage = "nh clean all --nogcroots";
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--color 16"
      ];
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.thefuck = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      git = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--color=always"
        "--no-quotes"
        "--hyperlink"
      ];
    };

    programs.ripgrep.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
