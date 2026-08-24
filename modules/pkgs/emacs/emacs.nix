{
  self,
  ...
}:
{
  perSystem =
    { pkgs, lib, ... }:
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
            fussy
            marginalia
            consult

            evil
            evil-collection
            evil-commentary
            general
            flyover
            company
            cape

            dirvish
            vterm

            magit # dependency of org-roam
            org-roam
            org-roam-ui
            org
            visual-fill-column
            org-modern
            ox-typst
            org-download
            pkgs'.ob-typst
            pkgs'.typst-overlay

            nix-ts-mode
            typst-ts-mode
          ]
          ++ extraEmacsPackages
        );

      runtimeDependencies = with pkgs; [
        # graphviz
        typst
        pkgs'.org-to-pdf
      ];
    in
    {
      packages = rec {
        emacs-ts-grammars = emacsPackages.treesit-grammars.with-all-grammars;

        # org-to-pdf = pkgs.writeShellApplication {
        #   name = "org-to-pdf";
        #   runtimeInputs = with pkgs; [
        #     python3
        #     typst
        #     pandoc
        #   ];
        #   text = ''
        #     python3 ${./org-to-pdf.py} "$@"
        #   '';
        # };

        org-to-pdf = pkgs.stdenv.mkDerivation {
          pname = "org-to-pdf";
          version = "0.1.0";
          src = ./typst;
          buildInputs = with pkgs; [
            python3
            pandoc
            typst
          ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            mkdir -p $out/share/org-to-pdf
            cp -r ./* $out/share/org-to-pdf
            makeWrapper ${pkgs.python3}/bin/python3 $out/bin/org-to-pdf \
              --add-flags "$out/share/org-to-pdf/main.py" \
              --prefix PATH : ${
                pkgs.lib.makeBinPath (
                  with pkgs;
                  [
                    pandoc
                    typst
                  ]
                )
              }
            runHook postInstall
          '';
        };

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
                --set EMACS_GRAMMAR_PATH "${emacs-ts-grammars}/lib" \
                --prefix PATH : "${lib.makeBinPath runtimeDependencies}"
            ''
        ) { };
      };
    };
}
