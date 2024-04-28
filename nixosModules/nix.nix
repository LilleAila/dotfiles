{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.nix = {
    unfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of allowed unfree package names, usually defined in allowUnfreePredicate.";
    };
  };
  config = {
    nixpkgs.config.allowUnsupportedSystem = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    # nixpkgs.config.allowUnfree = true; # Nuh uh
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.settings.nix.unfree;
  };
}
