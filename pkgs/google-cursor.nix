{
  pkgs,
  stdenv,
  fetchFromGitHub,
  python3,
  clickgen,
  nodejs,
  inkscape,
  ...
}: {
  bc, # Background
  oc, # Outline
}:
# let
#   bc = "#000000";
#   oc = "#FFFFFF";
# in
stdenv.mkDerivation {
  name = "google-cursor-custom";
  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Google_Cursor";
    rev = "7e416f8ae074a9346bf860961a0c4d47a58f4f00";
    hash = "sha256-ON4dwn24sc+8gSErelBsCQo4PLb7Vy6/x7JfXyuvg+4=";
  };

  nativeBuildInputs = [
    clickgen
    (pkgs.callPackage ./cbmp.nix {})
    inkscape
  ];

  # '' is escaped with another '
  postPatch = ''
    substituteInPlace build.toml \
      --replace "bitmaps_dir = '''" \
      "bitmaps_dir = 'bitmaps/GoogleDot-Custom'"

    substituteInPlace build.toml \
      --replace "platforms = ['x11', 'windows']" \
      "platforms = ['x11']"
    substituteInPlace build.toml \
      --replace "x11_sizes = [22, 24, 28, 32, 40, 48, 56, 64, 72, 80, 88, 96]" \
      ""
    substituteInPlace build.toml \
      --replace "win_size = 32" \
      ""
    sed -i "/\[cursors.fallback_settings\]/a x11_sizes = [22, 24, 28, 32, 40, 48, 56, 64, 72, 80, 88, 96]" build.toml

    substituteInPlace build.toml \
      --replace "png = 'left_ptr_watch-*.png'" \
      "png = 'left_ptr_watch.png'"
    substituteInPlace build.toml \
      --replace "png = 'wait-*.png'" \
      "png = 'wait.png'"


    substituteInPlace build.toml \
      --replace "name = 'Google Cursor'" \
      "name = 'GoogleDot-Custom'"
  '';

  # The `cbmp` command doesn't work in the buildPhase for some reason??
  # It does however work when running it directly from the terminal
  buildPhase = ''
    # cbmp -d 'svg' -o 'bitmaps/GoogleDot-Custom' -bc '${bc}' -oc '${oc}'
    find svg/ -name "*.svg" -exec sed -i 's/#00FF00/${bc}/g' {} \;
    find svg/ -name "*.svg" -exec sed -i 's/#FF0000/${bc}/g' {} \;
    find svg/ -name "*.svg" -exec sed -i 's/#0000FF/${oc}/g' {} \;
    mkdir -p bitmaps/GoogleDot-Custom
    find svg/ -name "*.svg" -exec sh -c 'inkscape --export-type=png --export-filename="bitmaps/GoogleDot-Custom/$(basename "{}" .svg).png" "{}"' \;
    ctgen build.toml
  '';

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r themes/GoogleDot-Custom $out/share/icons/
  '';
}
