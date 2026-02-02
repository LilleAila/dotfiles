{ lib, ... }:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
}
