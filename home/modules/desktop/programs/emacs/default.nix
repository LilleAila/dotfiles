{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
# https://github.com/ircurry/cfg/blob/master/home/programs/emacs/default.nix
let
  # NOTE: The -pgtk version does NOT work with EXWM
  emacs-package =
    with pkgs;
    ((emacsPackagesFor emacs29-pgtk).emacsWithPackages (
      # emacs-package = with pkgs; ((emacsPackagesFor emacs29).emacsWithPackages (
      epkgs: [
        # === Use-package ===
        epkgs.use-package
        # ( import ./eaf.nix { inherit pkgs; })

        # === Completion ===
        epkgs.ivy
        epkgs.ivy-rich
        epkgs.counsel
        epkgs.swiper
        epkgs.helpful

        # === UI ===
        epkgs.doom-themes
        epkgs.all-the-icons
        epkgs.doom-modeline

        # === Keybinds ===
        epkgs.evil
        epkgs.evil-collection
        epkgs.which-key
        epkgs.general
        epkgs.hydra

        # === IDE ===
        epkgs.lsp-mode
        epkgs.lsp-ui
        epkgs.lsp-treemacs
        epkgs.lsp-ivy
        epkgs.company
        epkgs.company-box
        epkgs.undo-tree
        epkgs.evil-nerd-commenter
        epkgs.typescript-mode

        # === Org-mode ===
        epkgs.org
        epkgs.org-bullets
        epkgs.visual-fill-column

        # === EXWM ===
        # epkgs.exwm
        # epkgs.exwm-modeline
      ]
    ));
  # emacs-python-deps = python-pkgs: with python-pkgs; [
  # ];
  emacs-deps = with pkgs; [
    # ( python311.withPackages emacs-python-deps )

    # === TypeScript ===
    nodejs
    nodePackages.npm
    nodePackages.typescript
    nodePackages.typescript-language-server

    # === EXWM ===
    # xorg.xinit
    # xorg.xmodmap
    # arandr
  ];
  emacs-wrapped = inputs.wrapper-manager.lib.build {
    inherit pkgs;
    modules = [
      {
        wrappers.emacs = {
          basePackage = emacs-package;
          pathAdd = emacs-deps;
        };
      }
    ];
  };
in
{
  options.settings.emacs.enable = lib.mkEnableOption "emacs";

  config = lib.mkIf config.settings.emacs.enable {
    programs.emacs = {
      enable = true;
      package = emacs-wrapped;
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
      package = emacs-wrapped;
      client.enable = true;
    };
  };
}
