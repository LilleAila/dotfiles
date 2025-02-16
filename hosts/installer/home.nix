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
  # i don't think home manager should be enabled on iso
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  settings = {
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
  sops.secrets."ssh/installer".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.installer.public;
  home.file.".config/sops/age/keys.txt".source = ../../secrets/sops-key.txt;
  home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc; # couldn't find a way to declaratively import
  home.packages = with pkgs; [
    jq
    fzf
    git
  ];

  home.file."install.sh" = {
    source = ./install.sh;
    executable = true;
  };

  home.file."post-install.sh" = {
    source = ./post-install.sh;
    executable = true;
  };
}
