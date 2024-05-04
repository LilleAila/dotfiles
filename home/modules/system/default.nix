{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  options.settings.nix.unfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "List of allowed unfree package names passed to nixpkgs config";
  };
}
