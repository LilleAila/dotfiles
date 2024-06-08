{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  libfprint-tod,
}:
# I have no idea how this is actually supposed to be installed
stdenv.mkDerivation {
  pname = "libfprint-2-tod1-fpc";
  version = "0.0.1";

  src = fetchzip {
    url = "https://download.lenovo.com/pccbbs/mobiles/r1slm02w.zip";
    sha256 = "sha256-/buXlp/WwL16dsdgrmNRxyudmdo9m1HWX0eeaARbI3Q=";
    stripRoot = false;
  };

  # nativeBuildInputs = [autoPatchelfHook];

  buildPhase = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath [libfprint-tod]} \
      FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so
    patchelf \
      --set-rpath ${lib.makeLibraryPath [libfprint-tod]} \
      FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so.2
    patchelf \
      --set-rpath ${lib.makeLibraryPath [libfprint-tod]} \
      FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so.2.0.0
    patchelf \
      --set-rpath ${lib.makeLibraryPath [libfprint-tod]} \
      FPC_driver_linux_27.26.23.39/install_fpc/libfpcbep.so
  '';

  installPhase = ''
    # runHook preInstall

    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d"

    # cp FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/* "$out/lib/libfprint-2/tod-1/"
    install -Dm444 FPC_driver_linux_27.26.23.39/install_fpc/libfpcbep.so -t "$out/lib/libfprint-2/tod-1"
    install -Dm444 FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so -t "$out/lib/libfprint-2/tod-1/"
    install -Dm444 FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so.2 -t "$out/lib/libfprint-2/tod-1/"
    install -Dm444 FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so.2.0.0 -t "$out/lib/libfprint-2/tod-1/"
    cp FPC_driver_linux_libfprint/install_libfprint/lib/udev/rules.d/60-libfprint-2-device-fpc.rules $out/lib/udev/rules.d/

    # runHook postInstall
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "FPC Fingerprint driver for ThinkPad E14 gen 5";
    homepage = "https://github.com/ramaureirac/thinkpad-e14-linux/blob/main/tweaks/fingerprint/README.md";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    # license = licenses.unfree;
    license = licenses.mit; # temporary, to make it easier to test
    platforms = platforms.linux;
    maintainers = with maintainers; [utkarshgupta137];
  };
}
