{
  emacsPackages,
  writeText,
  lib,
  colorScheme,
  ...
}:
with lib.attrsets.mapAttrs (_: c: "#${c}") colorScheme.palette;
emacsPackages.trivialBuild {
  pname = "base16-nix-colors-theme"; # Would use theme slug, but having it static avoids needing to pass values to the .el files
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
          "Base16 ${colorScheme.slug}")

        ;; Define the theme
        (deftheme base16-nix-colors)

        ;; Add all the faces to the theme
        (base16-theme-define 'base16-nix-colors base16-colorscheme-colors)

        ;; Mark the theme as provided
        (provide-theme 'base16-nix-colors)

        ;; Add path to theme to theme-path
        (add-to-list 'custom-theme-load-path
            (file-name-directory
                (file-truename load-file-name)))

        (provide 'base16-nix-colors-theme)
      '';
}
