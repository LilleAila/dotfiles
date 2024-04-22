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
  name = "Apple-Custom";
  svg_dir = "svg/monterey";
  source = fetchFromGitHub {
    owner = "ful1e5";
    repo = "apple_cursor";
    rev = "7af6c433dc72d0f2eab022e7e8c1bb989a4bb468";
    hash = "sha256-2EH+6PE2ABeyUSUgXShKTZDfNp/P/vIaXHlZhweiyOA=";
  };
}
