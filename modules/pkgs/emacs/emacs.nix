# TODO
{
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
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

            self.packages.${pkgs.stdenv.hostPlatform.system}.emacs-theme

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

            nix-ts-mode
          ]
          ++ extraEmacsPackages
        );
      ts-grammars = emacsPackages.treesit-grammars.with-all-grammars;
    in
    {
      packages = rec {
        emacs-unwrapped = pkgs.callPackage (
          {
            extraEmacsPackages ? [ ],
          }:
          emacsPackage extraEmacsPackages
        ) { };
        # emacs-config = ./.;
        emacs-config = pkgs.runCommand "emacs-config-dir" { } ''
          cp -r ${./.} $out;
        '';
        emacs-ts-grammars = ts-grammars;
        emacs =
          pkgs.runCommand "emacs-config"
            {
              nativeBuildInputs = [ pkgs.makeWrapper ];
              meta.mainProgram = "emacs";
            }
            ''
              cp -rs ${emacs-unwrapped} $out
              chmod -R a+w $out/*
              wrapProgram $out/bin/emacs \
                --add-flags "--init-directory=${emacs-config}" \
                --set EMACS_GRAMMAR_PATH "${emacs-ts-grammars}/lib"
            '';
      };
    };
}
