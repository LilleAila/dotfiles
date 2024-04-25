{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  options.settings.fcitx5.enable = lib.mkEnableOption "fcitx5";

  config = lib.mkIf (config.settings.fcitx5.enable) {
    wayland.windowManager.hyprland.settings.exec-once = [
      "fcitx5 -d"
    ];

    # wtf fcitx5 overwrites read-only files, so i have to do this thing to make the folder itself readonly
    home.file.".config/fcitx5".source = pkgs.stdenv.mkDerivation {
      name = "fcitx5-config";
      src = ./cfg;
      buildPhase = ''
        mkdir -p conf
        cat > conf/classicui.conf << EOF
        ${import ./classicui.nix {inherit config;}}
        EOF
      '';
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out
      '';
    };

    home.file.".local/share/fcitx5/themes".source = pkgs.stdenv.mkDerivation {
      name = "fcitx5-theme";
      src = ./themes;
      buildPhase = ''
        mkdir -p nix-colors
        cat > nix-colors/theme.conf << EOF
        ${import ./theme.nix {inherit config;}}
        EOF
      '';
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out
      '';
    };
  };
}
