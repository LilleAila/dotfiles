{ lib, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.emacs-theme = pkgs.callPackage (
        {
          emacsPackages,
          writeText,
          ...
        }:
        with lib.attrsets.mapAttrs (_: c: "#${c}") self.colorScheme.palette;
        emacsPackages.trivialBuild {
          pname = "base16-nix-colors-theme";
          version = "0.0.1";
          packageRequires = [ emacsPackages.base16-theme ];
          src =
            writeText "base16-nix-colors-theme.el" # lisp
              ''
                (require 'base16-theme)

                (defvar base16-colorscheme-colors
                  '(:base00 "${base00}"
                    :base01 "${base01}"
                    :base02 "${base02}"
                    :base03 "${base03}"
                    :base04 "${base04}"
                    :base05 "${base05}"
                    :base06 "${base06}"
                    :base07 "${base07}"
                    :base08 "${base08}"
                    :base09 "${base09}"
                    :base0A "${base0A}"
                    :base0B "${base0B}"
                    :base0C "${base0C}"
                    :base0D "${base0D}"
                    :base0E "${base0E}"
                    :base0F "${base0F}")
                  "Base16 ${self.colorScheme.slug}")

                (deftheme base16-nix-colors)
                (base16-theme-define 'base16-nix-colors base16-colorscheme-colors)
                (provide-theme 'base16-nix-colors)
                (add-to-list 'custom-theme-load-path
                    (file-name-directory
                        (file-truename load-file-name)))

                (provide 'base16-nix-colors-theme)
              '';
        }
      ) { };
    };
}
