{
  lib,
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.ewm =
    {
      config,
      pkgs,
      ...
    }:
    {
      options.settings.ewm.enable = lib.mkEnableOption "ewm";

      imports = [ inputs.ewm.nixosModules.default ];

      config =
        let
          pkgs' = self.packages.${pkgs.stdenv.hostPlatform.system};
        in
        lib.mkIf config.settings.ewm.enable {
          # nixpkgs.overlays = [
          #   (final: prev: {
          #     libdisplay-info = prev.libdisplay-info_0_2;
          #   })
          # ];

          programs.ewm = {
            enable = true;
            extraEmacsArgs = "--init-directory ${pkgs'.emacs-config}";
            emacsPackage = pkgs'.emacs-unwrapped.override {
              extraEmacsPackages = [ config.programs.ewm.ewmPackage ];
            };
          };
        };
    };
}
