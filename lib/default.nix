{
  lib,
  callPackage,
}:
{
  colors = callPackage ./colors.nix {};
}
// callPackage ./options.nix {}
