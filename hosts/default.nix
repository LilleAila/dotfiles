{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./config
  ];

  # Temporary patch for backdoor in xz
  # All systems must temporarily be built with --impure
  system.replaceRuntimeDependencies = [
    {
      original = pkgs.xz;
      replacement = inputs.nixpkgs-staging.legacyPackages.${pkgs.system}.xz;
    }
  ];
}
