{ lib, ... }:
{
  flake.modules.homeManager.nix-unfree =
    {
      pkgs,
      inputs,
      config,
      isStandalone,
      ...
    }:
    {
      imports = [ ];

      # Read from system configuration
      options.settings.nix.unfree = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of allowed unfree package names passed to nixpkgs config";
      };

      config = lib.mkIf isStandalone {
        nixpkgs.config =
          let
            unfreePkgs = config.settings.nix.unfree;
          in
          {
            allowUnsupportedSystem = true;
            allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePkgs;
          };
      };
    };
}
