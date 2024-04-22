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
  name = "GoogleDot-Custom";
  source = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Google_Cursor";
    rev = "7e416f8ae074a9346bf860961a0c4d47a58f4f00";
    hash = "sha256-ON4dwn24sc+8gSErelBsCQo4PLb7Vy6/x7JfXyuvg+4=";
  };
}
# pkgs.callPackage ./cursors2.nix {}

