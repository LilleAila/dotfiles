{
  lib,
  inputs,
  self,
  ...
}:
let
in
{
  flake.modules.nixos.ewm =
    {
      config,
      pkgs,
      ...
    }:
    let
      pkgs' = self.packages.${pkgs.stdenv.hostPlatform.system};

      emacs-config = pkgs'.emacs-config.override {
        extraConfig = builtins.readFile ./ewm-init.el;
      };

      emacsPackage = pkgs'.emacs-unwrapped.override {
        extraEmacsPackages = [ config.programs.ewm.ewmPackage ];
      };
    in
    {
      options.settings.ewm.enable = lib.mkEnableOption "ewm";

      imports = [ inputs.ewm.nixosModules.default ];

      config = lib.mkIf config.settings.ewm.enable {
        # causes infinite recursion. instead patched upstream. TODO submit a PR
        # nixpkgs.overlays = [
        #   (final: prev: {
        #     libdisplay-info = prev.libdisplay-info_0_2;
        #   })
        # ];

        programs.ewm = {
          enable = true;
          extraEmacsArgs = "--init-directory ${emacs-config}";
          inherit emacsPackage;
        };
      };
    };
}
