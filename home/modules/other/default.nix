{
  pkgs,
  lib,
  inputs,
  config,
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
}
