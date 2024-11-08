# Basically stolen from steam-run in nixpkgs
{ pkgs, ... }:
pkgs.buildFHSEnv {
  name = "fhsenv";
  runScript = "$@"; # Needed for some reason
  multiPkgs =
    pkgs: with pkgs; [
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libva
      pipewire

      # steamwebhelper
      harfbuzz
      libthai
      pango

      lsof # friends options won't display "Launch Game" without it
      file # called by steam's setup.sh

      # dependencies for mesa drivers, needed inside pressure-vessel
      mesa.llvmPackages.llvm.lib
      vulkan-loader
      expat
      wayland
      xorg.libxcb
      xorg.libXdamage
      xorg.libxshmfence
      xorg.libXxf86vm
      elfutils

      # Without these it silently fails
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libSM
      xorg.libICE
      gnome2.GConf
      curlWithGnuTls
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      gsettings-desktop-schemas
      ffmpeg
      libudev0-shim

      # Verified games requirements
      fontconfig
      freetype
      xorg.libXt
      xorg.libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      libdrm
      libidn
      tbb
      zlib

      # SteamVR
      udev
      dbus

      # Other things from runtime
      glib
      gtk2
      bzip2
      flac
      freeglut
      libjpeg
      libpng
      libpng12
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk2
      libdbusmenu-gtk2
      libindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libunwind
      libvpx
      librsvg
      xorg.libXft
      libvdpau

      # required by coreutils stuff to run correctly
      # Steam ends up with LD_LIBRARY_PATH=<bunch of runtime stuff>:/usr/lib:<etc>
      # which overrides DT_RUNPATH in our binaries, so it tries to dynload the
      # very old versions of stuff from the runtime.
      # FIXME: how do we even fix this correctly
      attr

      # Optional game-specific dependencies from steam-run source
      # Not formally in runtime but needed by some games
      at-spi2-atk
      at-spi2-core # CrossCode
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-base
      json-glib # paradox launcher (Stellaris)
      libdrm
      libxkbcommon # paradox launcher
      libvorbis # Dead Cells
      libxcrypt # Alien Isolation, XCOM 2, Company of Heroes 2
      mono
      ncurses # Crusader Kings III
      openssl
      xorg.xkeyboardconfig
      xorg.libpciaccess
      xorg.libXScrnSaver # Dead Cells
      icu # dotnet runtime, e.g. Stardew Valley

      # screeps dependencies
      gtk3
      zlib
      atk
      cairo
      freetype
      gdk-pixbuf
      fontconfig

      # Prison Architect
      libGLU
      libuuid
      libbsd
      alsa-lib

      # Loop Hero
      # FIXME: Also requires openssl_1_1, which is EOL. Either find an alternative solution, or remove these dependencies (if not needed by other games)
      libidn2
      libpsl
      nghttp2.lib
      rtmpdump

      # Factorio
      libpulseaudio
    ];
}
