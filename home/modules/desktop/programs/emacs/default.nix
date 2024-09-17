{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
# https://github.com/ircurry/cfg/blob/master/home/programs/emacs/default.nix
let
  # TODO: maybe use the emacs-overlay?
  # NOTE: The -pgtk version does NOT work with EXWM
  emacs-package = (pkgs.emacsPackagesFor pkgs.emacs29-pgtk).emacsWithPackages (
    epkgs: with epkgs; [
      # === Use-package ===
      use-package

      # === Completion ===
      ivy
      ivy-rich
      counsel
      swiper
      helpful

      # === UI ===
      all-the-icons
      pkgs.emacs-all-the-icons-fonts
      doom-modeline
      (pkgs.callPackage ./theme.nix { inherit (config) colorScheme; })

      # === Keybinds ===
      evil
      evil-collection
      which-key
      general
      hydra

      # === IDE ===
      lsp-mode
      lsp-ui
      lsp-treemacs
      lsp-ivy
      company
      company-box
      undo-tree
      evil-nerd-commenter
      direnv

      # === Languages ===
      typescript-mode

      # === Org-mode ===
      org
      org-bullets
      visual-fill-column
    ]
  );
in
{
  options.settings.emacs.enable = lib.mkEnableOption "emacs";

  config = lib.mkIf config.settings.emacs.enable {
    programs.emacs = {
      enable = true;
      package = emacs-package;
    };

    home.file.".emacs.d" = {
      source = lib.cleanSourceWith {
        filter =
          name: _type:
          let
            baseName = baseNameOf (toString name);
          in
          !(lib.hasSuffix ".nix" baseName);
        src = lib.cleanSource ./.;
      };
      recursive = true;
    };

    # Restart with systemctl --user restart emacs
    services.emacs = {
      enable = true;
      package = emacs-package;
      client.enable = true;
    };
  };
}
