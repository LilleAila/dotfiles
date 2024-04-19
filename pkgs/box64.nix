{
  pkgs,
  stdenv,
  cmake,
  python3,
  ...
}:
stdenv.mkDerivation {
  name = "box64";
  src = pkgs.fetchFromGitHub {
    owner = "ptitSeb";
    repo = "box64";
    rev = "cb6616bba13d61b130be53b32db1740becee03d3";
    hash = "sha256-0ZFgOLCy/E7A1t0dzgHgkzeT1Nu94Fn6Bbz7Cih2KuQ=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    "-DNOGIT=ON"
    "-DARM64=true"
    "-DARM_DYNAREC=true"
    "-D M1=1"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 box64 "$out/bin/box64"

    runHook postInstall
  '';
}
