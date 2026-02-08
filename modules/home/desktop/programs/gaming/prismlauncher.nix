{ lib, ... }:
{
  flake.modules.homeManager.prismlauncher =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    let
      java8 = pkgs.temurin-bin-8;
      java17 = pkgs.temurin-bin-17;
      java21 = pkgs.temurin-bin-21;
    in
    lib.mkIf config.settings.gaming.enable {
      home.packages = [
        (pkgs.prismlauncher.override {
          jdks = [
            java8
            java17
            java21
          ];
        })
      ];

      settings.persist.home.cache = [ ".local/share/PrismLauncher" ];

      # I don't like this :(
      # home.activation = {
      #   prismLauncherJavaPath = lib.hm.dag.entryAfter ["writeBoundary"] ''
      #     sed -i "/JavaPath/s|=.*$|=${lib.getExe java21}|" $HOME/.local/share/PrismLauncher/instances/1.21/instance.cfg
      #   '';
      # };

      home.file.".local/share/PrismLauncher/prismlauncher.cfg".text = lib.generators.toINI { } {
        General = {
          ApplicationTheme = "system"; # Or dark
          MenuBarInsteadOfToolBar = true;
          CloseAfterLaunch = true;
          IconTheme = "flat_white";
          Language = "en_US";
          ShowGameTimeWithoutDays = true;

          EnableFeralGamemode = true;
          UseNativeGLFW = true;
          CustomGLFWPath = "/run/opengl-driver/lib/libglfw.so";
          # Most recent versions use java 17
          JavaPath = lib.getExe java17;
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
    };
}
