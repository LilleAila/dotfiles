{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  options.settings.fonts = with lib; let
    fontType = types.submodule {
      options = {
        package = mkOption {
          description = "Package providing the font";
          type = types.package;
        };

        name = mkOption {
          description = "Name of the font within the package";
          type = types.str;
        };
      };
    };
  in {
    # Fonts are not disablable
    # enable = mkEnableOption "Fonts";

    serif = mkOption {
      description = "Serif font";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };

    sansSerif = mkOption {
      description = "Sans-serif font";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
    };

    monospace = mkOption {
      description = "Monospace font";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
    };

    nerd = mkOption {
      description = "Nerd Font (icons)";
      type = fontType;
      default = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font";
      };
    };

    emoji = mkOption {
      description = "Emoji font";
      type = fontType;
      default = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    size = mkOption {
      description = "Font size";
      type = types.int;
      default = 10;
    };
  };

  config = {
    fonts.fontconfig.enable = true;
    home.packages = with config.settings.fonts; [
      serif.package
      sansSerif.package
      monospace.package
      emoji.package
    ];
  };
}
