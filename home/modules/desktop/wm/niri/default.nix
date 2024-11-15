{
  config,
  lib,
  pkgs,
  inputs,
  isNixOS,
  ...
}:
{
  options.settings.niri.enable = lib.mkEnableOption "niri";

  # The NixOS module will automatically import this too.
  # imports = [ inputs.niri.homeModules.niri ];

  config = lib.mkIf config.settings.niri.enable {
    # programs.niri = lib.mkIf (!isNixOS) {
    #   enable = true;
    #   package = pkgs.niri-stable;
    # };
    programs.niri.settings = { };
  };
}
