{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [../../home];

  # https://github.com/tinted-theming/base16-schemes/
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
    # emacs.enable = true;
    terminal = {
      zsh = {
        enable = true;
        theme = "nanotech";
      };
      utils.enable = true;
      neovim.enable = true;
    };
  };
  home.username = lib.mkForce "nixos";
}
