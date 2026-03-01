{ lib, ... }:
{
  flake.modules.homeManager.dvd =
    { config, pkgs, ... }:
    let
      cfg = config.settings.dvd;
    in
    {
      options.settings.dvd.enable = lib.mkEnableOption "dvd";

      config = lib.mkIf cfg.enable {
        settings = {
          nix.unfree = [
            "makemkv"
          ];

          persist.home.directories = [
            ".MakeMKV"
          ];
        };

        home.packages = with pkgs; [
          makemkv # did not recognise the drive :(
          libdvdcss
          dvdbackup
          ffmpeg
          vlc
          lsdvd
          ddrescue
          handbrake
        ];
      };
    };
}
