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
      };
    };
}
