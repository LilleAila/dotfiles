{
  pkgs,
  stdenv,
  fetchFromGitHub,
  python3,
  clickgen,
  nodejs,
  inkscape,
  ...
}:
# {
#   bc, # Background
#   oc, # Outline
# }:
let
  bc = "#000000";
  oc = "#FFFFFF";
in
  stdenv.mkDerivation {
    name = "google-cursor-custom";
    src = fetchFromGitHub {
      owner = "ful1e5";
      repo = "Google_Cursor";
      rev = "7e416f8ae074a9346bf860961a0c4d47a58f4f00";
      hash = "sha256-ON4dwn24sc+8gSErelBsCQo4PLb7Vy6/x7JfXyuvg+4=";
    };
    nativeBuildInputs = [
      (python3.withPackages (p: [p.clickgen]))
      clickgen
      nodejs
      pkgs.tree
      inkscape
    ];

    buildPhase =
      /*
      bash
      */
      ''
        find svg/ -name "*.svg" -exec sed -i 's/#00FF00/${bc}/g' {} \;
        find svg/ -name "*.svg" -exec sed -i 's/#0000FF/${oc}/g' {} \;
        find svg/ -name "*.svg" -exec sed -i 's/#FF0000/${bc}/g' {} \;
        mkdir -p bitmaps/GoogleDot-Custom
        find svg/ -type f -name "*.svg" -exec sh -c 'inkscape -o "bitmaps/GoogleDot-Custom/$(basename "{}" .svg).png" "{}"' \;
        ctgen build.toml -d 'bitmaps/GoogleDot-Custom' -n 'GoogleDot-Custom' -c 'GoogleDot nix-colors'
        tree
      '';

    installPhase =
      /*
      bash
      */
      ''
        mkdir -p $out/share/icons
        cp -r GoogleDot-* $out/share/icons
      '';
  }
