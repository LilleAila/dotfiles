{ lib, self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        ob-typst = pkgs.emacsPackages.trivialBuild {
          pname = "ob-typst";
          version = "master";

          src = pkgs.fetchFromGitHub {
            owner = "Cj-bc";
            repo = "ob-typst";
            rev = "fa4aeb8d28e287f3d89c488e371bb93e62e7db8b";
            hash = "sha256-fltKyXmSEhHvLy/HgFGF9DxdYzNnST5FPyCB3tmfyTA=";
          };

          propagatedUserEnvPkgs = [ pkgs.typst ];

          postInstall = ''
            mkdir -p $out/share/emacs/site-lisp/
            cp $src/ob-typst.el $out/share/emacs/site-lisp/
          '';
        };

        typst-overlay = pkgs.emacsPackages.trivialBuild {
          pname = "typst-overlay";
          version = "master";

          src = pkgs.fetchFromGitHub {
            owner = "hesampakdaman";
            repo = "typst-overlay";
            rev = "292cea49c5073a54b02aa5eb12467a4ac9919097";
            hash = "sha256-Ew7t4bVxJ9GqaYFqV8esUqAfs1nKzZbnNkdkOS88nv4=";
          };

          propagatedUserEnvPkgs = [ pkgs.typst ];

          postInstall = ''
            mkdir -p $out/share/emacs/site-lisp/
            cp $src/typst-overlay.el $out/share/emacs/site-lisp/
          '';
        };
      };
    };
}
