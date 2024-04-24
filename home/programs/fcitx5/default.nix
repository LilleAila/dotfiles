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
      "fcitx5"
    ];

    # home.file.".config/fcitx5/config".source = ./config;
    # home.file.".config/fcitx5/profile".source = ./profile;
    # home.file.".config/fcitx5/conf/classicui.conf".text = import ./classicui.nix {inherit config;};

    # wtf fcitx5 overwrites read-only files
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
  };
}
