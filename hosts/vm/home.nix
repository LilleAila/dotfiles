{
  config,
  pkgs,
  inputs,
  lib,
  keys,
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
    # other.enable = true;
  };

  sops.secrets."ssh/installer".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.installer.public;
}
