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
  svg_dir ? "svg",
  extra_commands ? "",
  ...
}:
stdenv.mkDerivation {
  name = "${name}";

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
  buildPhase =
    ''
      # cbmp -d 'svg' -o 'bitmaps/GoogleDot-Custom' -bc '${background_color}' -oc '${outline_color}'

      find ${svg_dir}/ -name "*.svg" -exec sed -i 's/#00FF00/${background_color}/gi' {} \;
      find ${svg_dir}/ -name "*.svg" -exec sed -i 's/#FF0000/${background_color}/gi' {} \;
      find ${svg_dir}/ -name "*.svg" -exec sed -i 's/black/${background_color}/g' {} \;
      find ${svg_dir}/ -name "*.svg" -exec sed -i 's/#0000FF/${outline_color}/gi' {} \;
      find ${svg_dir}/ -name "*.svg" -exec sed -i 's/white/${outline_color}/g' {} \;
    ''
    + extra_commands
    + ''
      mkdir -p bitmaps/${name}
      find ${svg_dir}/ -name "*.svg" -exec sh -c 'inkscape --export-type=png --export-filename="bitmaps/${name}/$(basename "{}" .svg).png" "{}"' \;

      ctgen build.toml
    '';

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r themes/${name} $out/share/icons/
    # mkdir -p $out
    # cp -r ./* $out
  '';
}
