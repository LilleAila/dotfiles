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
  name = "Breeze-Custom";
  source = fetchFromGitHub {
    owner = "ful1e5";
    repo = "BreezeX_Cursor";
    rev = "0bd66a8edbe4f72ced44c4221b4ea55270f781e0";
    hash = "sha256-MppGh7UYo8OhTyuaYHVpqDlReLtkHJ7MiTmzfTMNvHw=";
  };
}
