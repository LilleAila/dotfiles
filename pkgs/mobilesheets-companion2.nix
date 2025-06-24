{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  icu,
  dpkg,
}:
stdenv.mkDerivation {
  pname = "mobilesheets-companion";
  version = "4.1.5";

  src = fetchurl {
    url = "https://www.zubersoft.download/MobileSheetsCompanion.deb";
    sha256 = "sha256-+vPwIjSVOayfD8M843LxBaRqqqoEBY9D/WIBSpQJpEE=";
  };

  dontBuild = true;
  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/libexec
    cp -r ./usr/lib/MobileSheetsCompanion/* $out/libexec/

    chmod +x $out/libexec/MobileSheetsCompanion

    mkdir -p $out/bin
    makeWrapper $out/libexec/MobileSheetsCompanion $out/bin/MobileSheetsCompanion \
      --set DOTNET_ROOT $out/libexec \
      --set LD_LIBRARY_PATH ${
        lib.makeLibraryPath [
          icu
          stdenv.cc.cc.lib
        ]
      }
  '';
}
