{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  icu,
}:
stdenv.mkDerivation {
  pname = "mobilesheets-companion";
  version = "0.0.0";

  src = fetchzip {
    url = "https://www.zubersoft.download/MobileSheetsCompanion.zip";
    sha256 = "sha256-IaBLvhHbtIU3cWF7CpF8zodhgpkhNRMfzvtC3lApDiw=";
    stripRoot = false;
  };

  dontBuild = true;
  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    icu
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out/libexec
    cp -r ./* $out/libexec/

    chmod +wx $out/libexec/MobileSheetsCompanion

    mkdir -p $out/bin
    makeWrapper $out/libexec/MobileSheetsCompanion $out/bin/MobileSheetsCompanion \
      --set DOTNET_ROOT $out/libexec/mobilesheets \
      --set LD_LIBRARY_PATH ${
        lib.makeLibraryPath [
          icu
          stdenv.cc.cc.lib
        ]
      }

  '';
}
