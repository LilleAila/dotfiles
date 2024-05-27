{
  lib,
  callPackage,
}:
{
  color = callPackage ./colors.nix {};
}
// callPackage ./options.nix {}
