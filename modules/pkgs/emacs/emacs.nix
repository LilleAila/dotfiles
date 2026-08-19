# TODO
{
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      pkgs' = self.packages.${pkgs.stdenv.hostPlatform.system};

      basePackage = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.emacs else pkgs.emacs-pgtk;
      emacsPackages = pkgs.emacsPackagesFor basePackage;
      emacsPackage =
        extraEmacsPackages:
        emacsPackages.emacsWithPackages (
          epkgs:
          with epkgs;
          [
            gcmh
            no-littering

            pkgs'.emacs-theme
            doom-modeline
            nerd-icons

            vertico
            orderless
            marginalia
            consult

            evil
            evil-collection
            evil-commentary
            general
            flyover
            corfu
            cape

            dirvish
            vterm

            magit # dependency of org-roam
            org-roam
            org
            visual-fill-column
            org-modern
            pkgs'.ob-typst
            pkgs'.typst-overlay

            nix-ts-mode
            typst-ts-mode
          ]
          ++ extraEmacsPackages
        );
    in
    {
      packages = rec {
        emacs-ts-grammars = emacsPackages.treesit-grammars.with-all-grammars;

        emacs-config = pkgs.callPackage (
          {
            extraConfig ? "",
          }:
          pkgs.runCommand "emacs-config-dir"
            {
              inherit extraConfig;
            }
            ''
              cp -r ${./.} $out;
              chmod -R a+w $out/*
              echo "$extraConfig" >> $out/init.el
            ''
        ) { };

        emacs-unwrapped = pkgs.callPackage (
          {
            extraEmacsPackages ? [ ],
          }:
          emacsPackage extraEmacsPackages
        ) { };

        emacsWithConfig = pkgs.callPackage (
          {
            emacsConfig ? emacs-config,
          }:
          pkgs.runCommand "emacs-config"
            {
              nativeBuildInputs = [ pkgs.makeWrapper ];
              meta.mainProgram = "emacs";
            }
            ''
              cp -rs ${emacs-unwrapped} $out
              chmod -R a+w $out/*
              wrapProgram $out/bin/emacs \
                --add-flags "--init-directory=${emacsConfig}" \
                --set EMACS_GRAMMAR_PATH "${emacs-ts-grammars}/lib"
            ''
        ) { };
      };
    };
}
