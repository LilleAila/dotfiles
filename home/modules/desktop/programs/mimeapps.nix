{ lib, config, ... }:
{
  options.settings.mimeApps.enable = lib.mkEnableOption "mime apps";

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
  # https://github.com/KDE/plasma-desktop/blob/master/kde-mimeapps.list
  config.xdg.mimeApps = lib.mkIf config.settings.mimeApps.enable {
    enable = true;
    associations.added = config.xdg.mimeApps.defaultApplications;
    defaultApplications = {
      "text/plain" = "nvim.desktop";
      "application/x-shellscript" = "nvim.desktop";
      "text/x-cmake" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "application/x-docbook+xml" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/x-yaml" = "nvim.desktop";
      "text/rhtml" = "nvim.desktop";
      "text/x-tex" = "nvim.desktop";
      "text/x-java" = "nvim.desktop";
      "text/x-ruby" = "nvim.desktop";
      "inode/x-empty" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "text/x-readme" = "nvim.desktop";
      "text/x-markdown" = "nvim.desktop";
      "application/x-ruby" = "nvim.desktop";

      "inode/directory" = "nemo.desktop";

      "image/avif" = "pix.desktop";
      "image/gif" = "pix.desktop";
      "image/heif" = "pix.desktop";
      "image/jpg" = "pix.desktop";
      "image/jpeg" = "pix.desktop";
      "image/jxl" = "pix.desktop";
      "image/png" = "pix.desktop";
      "image/bmp" = "pix.desktop";
      "image/x-eps" = "pix.desktop";
      "image/x-icns" = "pix.desktop";
      "image/x-ico" = "pix.desktop";
      "image/x-portable-bitmap" = "pix.desktop";
      "image/x-portable-graymap" = "pix.desktop";
      "image/x-portable-pixmap" = "pix.desktop";
      "image/x-xbitmap" = "pix.desktop";
      "image/x-xpixmap" = "pix.desktop";
      "image/tiff" = "pix.desktop";
      "image/x-psd" = "pix.desktop";
      "image/x-webp" = "pix.desktop";
      "image/webp" = "pix.desktop";
      "image/x-tga" = "pix.desktop";
      "image/svg+xml" = "pix.desktop";

      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/vnd.djvu" = "org.pwmt.zathura.desktop";

      "video/3gp" = "mpv.desktop";
      "video/3gpp" = "mpv.desktop";
      "video/3gpp2" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/divx" = "mpv.desktop";
      "video/dv" = "mpv.desktop";
      "video/fli" = "mpv.desktop";
      "video/flv" = "mpv.desktop";
      "video/mp2t" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mp4v-es" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/msvideo" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/vnd.divx" = "mpv.desktop";
      "video/vnd.mpegurl" = "mpv.desktop";
      "video/vnd.rn-realvideo" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-avi" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/x-m4v" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/x-mpeg2" = "mpv.desktop";
      "video/x-ms-asf" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";
      "video/x-ms-wmv" = "mpv.desktop";
      "video/x-ms-wmx" = "mpv.desktop";
      "video/x-ogm" = "mpv.desktop";
      "video/x-ogm+ogg" = "mpv.desktop";
      "video/x-theora" = "mpv.desktop";
      "video/x-theora+ogg" = "mpv.desktop";
      "application/x-matroska" = "mpv.desktop";

      "audio/aac" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/mpegurl" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/vnd.rn-realaudio" = "mpv.desktop";
      "audio/vorbis" = "mpv.desktop";
      "audio/x-flac" = "mpv.desktop";
      "audio/x-mp3" = "mpv.desktop";
      "audio/x-mpegurl" = "mpv.desktop";
      "audio/x-ms-wma" = "mpv.desktop";
      "audio/x-musepack" = "mpv.desktop";
      "audio/x-oggflac" = "mpv.desktop";
      "audio/x-pn-realaudio" = "mpv.desktop";
      "audio/x-scpls" = "mpv.desktop";
      "audio/x-speex" = "mpv.desktop";
      "audio/x-vorbis" = "mpv.desktop";
      "audio/x-vorbis+ogg" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";

      "text/html" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
    };
  };
}
