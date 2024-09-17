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
      epkgs: with epkgs; [
        # === Use-package ===
        use-package
        # ( import ./eaf.nix { inherit pkgs; })

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
        typescript-mode

        # === Org-mode ===
        org
        org-bullets
        visual-fill-column
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
