{
  stdenv,
  clickgen,
  inkscape,
  # Input variables
  source,
  name,
  background_color, # Background color
  outline_color, # Outline color
  accent_color, # Accent color
  ...
}:
stdenv.mkDerivation {
  name = "${name}";

  # src = fetchFromGitHub {
  #   owner = "ful1e5";
  #   repo = "Google_Cursor";
  #   rev = "7e416f8ae074a9346bf860961a0c4d47a58f4f00";
  #   hash = "sha256-ON4dwn24sc+8gSErelBsCQo4PLb7Vy6/x7JfXyuvg+4=";
  # };

  # src = fetchFromGitHub {
  #   owner = "ful1e5";
  #   repo = "fuchsia-cursor";
  #   rev = "aad95a3fef84a9682fcc536c8188f0b3da5788db";
  #   hash = "sha256-iSoaEmypFQfule+IoeXhhjKjYeKczAZkWhOSOacrijg=";
  # };

  src = source;

  nativeBuildInputs = [
    clickgen
    # Ended up not using lol
    # (pkgs.callPackage ./cbmp.nix {})
    inkscape
  ];

  # '' is escaped with another '
  postPatch = ''
    substituteInPlace build.toml \
      --replace "bitmaps_dir = '''" \
      "bitmaps_dir = 'bitmaps/${name}'"

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

    sed -i "s/^name = '[^']*'/name = '${name}'/g" build.toml
  '';

  # The `cbmp` command doesn't work in the buildPhase for some reason??
  # It does however work when running it directly from the terminal
  # Also the animated ones aren't animated
  buildPhase = ''
    # cbmp -d 'svg' -o 'bitmaps/GoogleDot-Custom' -bc '${background_color}' -oc '${outline_color}'

    find svg/ -name "*.svg" -exec sed -i 's/#00FF00/${background_color}/g' {} \;
    find svg/ -name "*.svg" -exec sed -i 's/#FF0000/${background_color}/g' {} \;
    find svg/ -name "*.svg" -exec sed -i 's/#0000FF/${outline_color}/g' {} \;

    sed -i "s/white/${outline_color}/g" svg/animated/wait.svg
    sed -i "s/#8c382a/${background_color}/g" svg/animated/wait.svg
    sed -i "s/#c5523f/${accent_color}/g" svg/animated/wait.svg

    sed -i "s/white/${outline_color}/g" svg/animated/left_ptr_watch.svg
    sed -i "s/#8c382a/${background_color}/g" svg/animated/left_ptr_watch.svg
    sed -i "s/#c5523f/${accent_color}/g" svg/animated/left_ptr_watch.svg

    sed -i "s/#FC3C36/${accent_color}/g" svg/static/zoom-out.svg
    sed -i "s/#00D161/${accent_color}/g" svg/static/zoom-in.svg

    mkdir -p bitmaps/${name}
    find svg/ -name "*.svg" -exec sh -c 'inkscape --export-type=png --export-filename="bitmaps/${name}/$(basename "{}" .svg).png" "{}"' \;

    ctgen build.toml
  '';

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r themes/${name} $out/share/icons/
    # mkdir -p $out
    # cp -r ./* $out
  '';
}
