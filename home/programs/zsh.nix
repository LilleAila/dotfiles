{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "dst";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
