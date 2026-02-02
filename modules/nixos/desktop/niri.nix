{ lib, ... }:
{
  flake.modules.nixos.niri =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings.niri.enable = lib.mkEnableOption "niri";

      imports = [ inputs.niri.nixosModules.niri ];

      config = lib.mkIf config.settings.niri.enable {
        nixpkgs.overlays = [ inputs.niri.overlays.niri ];

        # NOTE: build first with niri disabled, then enable after cache is added
        programs.niri = {
          enable = true;
          package = pkgs.niri-stable;
        };
      };
    };
}
