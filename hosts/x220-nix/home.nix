{
  config,
  pkgs,
  inputs,
  lib,
  keys,
  ...
}:
{
  imports = [ ../../home ];

  # https://github.com/tinted-theming/base16-schemes/
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
    # TODO configure settings
    terminal = {
      zsh = {
        enable = true;
        theme = "nanotech";
      };
      utils.enable = true;
      # neovim.enable = true;
    };
  };

  # FIXME temporary ssh key, replace with a new one as soon as possible
  sops.secrets."ssh/installer".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.installer.public;

  # Needed to decrypt the other secrets
  home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc;
}
