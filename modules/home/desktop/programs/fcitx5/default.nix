{ self, lib, ... }:
{
  flake.modules.homeManager.fcitx5 =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      options.settings.fcitx5.enable = lib.mkEnableOption "fcitx5";

      config = lib.mkIf config.settings.fcitx5.enable {
        wayland.windowManager.hyprland.settings.exec-once = [ "fcitx5 -d" ];
        wayland.windowManager.sway.config.startup = [ { command = "fcitx5 -d"; } ];

        # wtf fcitx5 overwrites read-only files, so i have to do this thing to make the folder itself readonly
        home.file.".local/share/fcitx5/themes".source = pkgs.stdenv.mkDerivation {
          name = "fcitx5-theme";
          src = ./themes; # really just a placeholder dir
          buildPhase = ''
            mkdir -p nix-colors
            cat > nix-colors/theme.conf << EOF
            ${import ./_theme.nix { inherit (self) colorScheme; }}
            EOF
          '';
          installPhase = ''
            mkdir -p $out
            cp -r ./* $out
          '';
        };
      };
    };
}
