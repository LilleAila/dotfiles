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
  name = "Bibata-Original-Custom";
  svg_dir = "svg/original";
  source = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "afb25d6e9ec30acc51e43e62e89792879e7be862";
    hash = "sha256-3S2eIJ6tEkMKWQqV3Az9R2wz48z9MljTx0Xi0jQ2AUA=";
  };
  # TODO: patch the other colors
  extra_commands = ''
  '';
}
