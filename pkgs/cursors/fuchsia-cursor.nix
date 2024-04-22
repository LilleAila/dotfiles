{
  fetchFromGitHub,
  pkgs,
  background_color ? "#000000",
  outline_color ? "#FFFFFF",
  accent_color ? "#999999",
  ...
}:
pkgs.callPackage ./cursors.nix {
  inherit background_color outline_color accent_color;
  name = "Fuchsia-Custom";
  source = fetchFromGitHub {
    owner = "ful1e5";
    repo = "fuchsia-cursor";
    rev = "aad95a3fef84a9682fcc536c8188f0b3da5788db";
    hash = "sha256-iSoaEmypFQfule+IoeXhhjKjYeKczAZkWhOSOacrijg=";
  };
}
