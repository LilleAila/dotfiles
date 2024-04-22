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
  extra_commands = ''
    sed -i "s/#75DDFB/${outline_color}/g" svg/monterey/animated/left_ptr_watch.svg
    sed -i "s/#37B4F6/${outline_color}/g" svg/monterey/animated/left_ptr_watch.svg
    sed -i "s/#50B3ED/${background_color}/g" svg/monterey/animated/left_ptr_watch.svg
    sed -i "s/#2960D9/${background_color}/g" svg/monterey/animated/left_ptr_watch.svg
    # I could do wait.svg, but there so many colors i no no wanna :(
    sed -i "s/#00C500/${accent_color}/g" svg/monterey/static/copy.svg
    sed -i "s/#009200/${accent_color}/g" svg/monterey/static/copy.svg
    sed -i "s/#F0F0F0/${accent_color}/g" svg/monterey/static/crossed_circle.svg
    sed -i "s/#D5D5D5/${accent_color}/g" svg/monterey/static/crossed_circle.svg
  '';
}
