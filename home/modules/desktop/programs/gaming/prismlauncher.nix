{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
lib.mkIf config.settings.gaming.enable {
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = with pkgs; [
        temurin-bin-8
        temurin-bin-17
        temurin-bin-21
      ];
    })
  ];

  settings.persist.home.cache = [".local/share/PrismLauncher"];

  home.file.".local/share/PrismLauncher/prismlauncher.cfg".text = lib.generators.toINI {} {
    General = {
      ApplicationTheme = "dark";
      CloseAfterLaunch = true;
      IconTheme = "flat_white";
      Language = "en_US";
      ShowGameTimeWithoutDays = true;

      EnableFeralGamemode = true;
      UseNativeGLFW = true;
      CustomGLFWPath = "/run/opengl-driver/lib/libglfw.so";
      # Most recent versions use java 17
      JavaPath = lib.getExe pkgs.temurin-bin-17;
      IgnoreJavaCompatibility = true;
      IgnoreJavaWizard = true;
      MaxMemAlloc = 4096;
      MinMemAlloc = 512;
    };
  };

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # So that the titlebar doean't show up outside the window and mess with the rendering
      "fakefullscreen, title:(Minecraft*)"
    ];
  };
}
