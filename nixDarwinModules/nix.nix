{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:
{
  options.settings.nix = {
    enable = lib.mkEnableOption "nix";
    unfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of allowed unfree package names";
    };
  };

  config = lib.mkIf config.settings.nix.enable {
    _module.args.stablePkgs = import inputs.nixpkgs-stable { inherit (pkgs) system; };

    nixpkgs = {
      hostPlatform = "aarch64-darwin";
      config =
        let
          unfreePkgs = config.settings.nix.unfree ++ config.hm.settings.nix.unfree;
        in
        {
          allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePkgs;
        };
    };

    nix = {
      package = pkgs.nixVersions.latest;

      # Could maybe be enabled again, as m1 pro is faster?
      optimise.automatic = false;
      gc.automatic = false;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        access-tokens = "github.com=${(import ../secrets/tokens.nix).github}";

        substituters = [
          "https://nix-community.cachix.org"
          "https://tweag-jupyter.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
        ];
      };

      registry.nixpkgs.flake = inputs.nixpkgs;
    };
  };
}
