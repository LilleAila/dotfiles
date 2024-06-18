# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=libfprint-fpcmoh-git
{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchzip,
  fetchpatch,
  pkg-config,
  meson,
  python3,
  ninja,
  gusb,
  pixman,
  glib,
  nss,
  gobject-introspection,
  coreutils,
  cairo,
  libgudev,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
}: let
  # driver_src = fetchzip {
  #   url = "https://download.lenovo.com/pccbbs/mobiles/r1slm02w.zip";
  #   sha256 = "sha256-/buXlp/WwL16dsdgrmNRxyudmdo9m1HWX0eeaARbI3Q=";
  #   stripRoot = false;
  # };
  driver_src = fetchzip {
    url = "https://download.lenovo.com/pccbbs/mobiles/r1slm01w.zip";
    sha256 = "sha256-/buXlp/WwL16dsdgrmNRxyudmdo9m1HWX0eeaARbI3Q=";
    stripRoot = false;
  };
  # libfpcbep = stdenv.mkDerivation {
  #   src = driver_src;
  #   buildPhase = ''
  #     libfpcbep_path=$(find ${driver_src} -name 'libfpcbep.so')
  #     cp -f $libfpcbep_path .
  #   '';
  # };
in
  stdenv.mkDerivation rec {
    pname = "libfprint";
    version = "1.94.6";
    outputs = ["out" "devdoc"];

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "libfprint";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-lDnAXWukBZSo8X6UEVR2nOMeVUi/ahnJgx2cP+vykZ8=";
    };

    patches = [
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/merge_requests/396.patch";
        sha256 = "sha256-+5B5TPrl0ZCuuLvKNsGtpiU0OiJO7+Q/iz1+/2U4Taw=";
      })
    ];

    postPatch = ''
      patchShebangs \
        tests/test-runner.sh \
        tests/unittest_inspector.py \
        tests/virtual-image.py \
        tests/umockdev-test.py \
        tests/test-generated-hwdb.sh

      libfpcbep_path=$(find ${driver_src} -name 'libfpcbep.so')
      cp -f $libfpcbep_path .
      sed -ibak "s+find_library[(]'fpcbep', required: true[)]+find_library('fpcbep', required: true, dirs: \'$(pwd)\')+g" ./meson.build

    '';

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
      gtk-doc
      docbook-xsl-nons
      docbook_xml_dtd_43
      gobject-introspection
    ];

    buildInputs = [
      gusb
      pixman
      glib
      nss
      cairo
      libgudev
    ];

    mesonFlags = [
      "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
      # Include virtual drivers for fprintd tests
      "-Ddrivers=all"
      "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
    ];

    nativeInstallCheckInputs = [
      (python3.withPackages (p: with p; [pygobject3]))
    ];

    # We need to run tests _after_ install so all the paths that get loaded are in
    # the right place.
    doCheck = false;

    doInstallCheck = true;

    postInstall = ''
      install -D $libfpcbep_path $out/lib/libfpcbep.so
      # patchelf --replace-needed libfpcbep.so $out/lib/libfpcbep.so libfprint/libfprint-2.so
      # patchelf --add-needed libfpcbep.so libfprint/libfprint-2.so
      install -Dm644 ${driver_src}/FPC_driver_linux_libfprint/install_libfprint/lib/udev/rules.d/60-libfprint-2-device-fpc.rules $out/lib/udev/rules.d/60-libfprint-2-device-fpc.rules
    '';

    installCheckPhase = ''
      runHook preInstallCheck

      ninjaCheckPhase

      runHook postInstallCheck
    '';

    meta = with lib; {
      homepage = "https://fprint.freedesktop.org/";
      description = "Library designed to make it easy to add support for consumer fingerprint readers";
      license = licenses.lgpl21Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [abbradar];
    };
  }
