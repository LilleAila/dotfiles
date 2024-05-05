{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.settings.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf config.settings.gaming.enable {
    # Other stuff like steam is enabled in system module gaming.nix
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };

    home.packages = with pkgs; [
      heroic
    ];
  };
}
