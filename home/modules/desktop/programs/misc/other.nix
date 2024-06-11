{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings = {
    imageviewer.enable = lib.mkEnableOption "imageviewer";
    other.enable = lib.mkEnableOption "other";
    blueman-applet.enable = lib.mkEnableOption "blueman applet";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.imageviewer.enable) {
      # Image viewers:
      # lxqt.lximage-qt (does not get themed bc QT and not GTK)
      # loupe (not the best UI)
      # feh (very minimal)
      # oculante (blurry and no theme)
      # cinnamon.pix (YES)
      # swayimg (good but has to be configed)
      # vimiv-qt (VIM but no theme)
      home.packages = [pkgs.cinnamon.pix];
      xdg.desktopEntries.pix = {
        name = "Pix";
        genericName = "Image viewer";
        icon = "pix";
        exec = "${lib.getExe' pkgs.cinnamon.pix "pix"} %f";
      };
      xdg.mimeApps.defaultApplications = {
        "image/png" = "pix.desktop";
        "image/jpg" = "pix.desktop";
        "image/jpeg" = "pix.desktop";
      };
    })
    # (lib.mkIf config.services.blueman-applet.enable {
    #   systemd.user.services.blueman-applet.Service.ExecStart = lib.mkForce "sleep 5 && ${lib.getExe' pkgs.blueman "blueman-applet"}";
    # })
    (lib.mkIf config.settings.blueman-applet.enable {
      wayland.windowManager.hyprland.settings.exec-once = [
        "${lib.getExe' pkgs.blueman "blueman-applet"}"
      ];
    })
    (lib.mkIf (config.settings.other.enable) {
      dconf.settings."org/blueman/general" = {
        plugin-list = ["!ConnectionNotifier"];
      };

      services.network-manager-applet.enable = true;

      xdg.mimeApps.enable = true;
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "zathura.desktop";
        "video/png" = "mpv.desktop";
        "video/jpg" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mov" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
      };

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        desktop = null;
        publicShare = null;
        templates = null;
      };

      programs.mpv = {
        enable = true;
        config = {
          keep-open = "always";
        };
      };

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
        ];
      };
    })
  ];
}
