{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  java8 = pkgs.temurin-bin-8;
  java17 = pkgs.temurin-bin-17;
  java21 = pkgs.temurin-bin-21;
in
lib.mkIf config.settings.gaming.enable {
  programs.prismlauncher = {
    enable = true;
    useSystemGLFW = true;
    package = pkgs.prismlauncher.override {
      jdks = [
        java8
        java17
        java21
      ];
    };
    settings = {
      General = {
        ApplicationTheme = "system"; # Or dark
        MenuBarInsteadOfToolBar = true;
        CloseAfterLaunch = true;
        IconTheme = "flat_white";
        Language = "en_US";
        ShowGameTimeWithoutDays = true;

        EnableFeralGamemode = true;
        # Most recent versions use java 17
        JavaPath = lib.getExe java17;
        IgnoreJavaCompatibility = true;
        IgnoreJavaWizard = true;
        MaxMemAlloc = 4096;
        MinMemAlloc = 512;
      };
    };
  };

  settings.persist.home.cache = [ ".local/share/PrismLauncher" ];

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # So that the titlebar doean't show up outside the window and mess with the rendering
      "fakefullscreen, title:(Minecraft*)"
    ];
  };
}
