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
      img = "kitty +kitten icat";

      neofetch = "${lib.getExe pkgs.nitch}";

      # osbuild = lib.mkDefault "nh os switch";
      osbuild = lib.mkDefault "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dotfiles --fast --no-build-nix";
      update-inputs = "nix run .#genflake flake.nix && nix flake lock";
      update-secrets = "nix flake lock --update-input secrets";
      nix-collect-garbage = "nh clean all --nogcroots --keep 4";
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

    home.packages = with pkgs; [
      nurl
      sops
      tldr
    ];
  };
}
