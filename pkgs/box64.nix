{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "box64";
  src = pkgs.fetchFromGitHub {
    owner = "ptitSeb";
    repo = "box64";
    rev = "4a889e39ad9a8b39119e71a8c9640affd3591a34";
    hash = "sha256-HviPNRWy7ScxNODPi7LbuNo08MbEd6/c9BtWhN9bA/E=";
  };

  nativeBuildInputs = with pkgs; [
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
