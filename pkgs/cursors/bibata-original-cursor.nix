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
  extra_commands = ''
    cp svg/original/left_ptr_watch/left_ptr_watch-01.svg svg/original/left_ptr_watch.svg
    cp svg/original/wait/wait-01.svg svg/original/wait.svg

    sed -i "s/#96C865/${background_color}/g" svg/original/bottom_left_corner.svg
    sed -i "s/#FDBE2A/${background_color}/g" svg/original/bottom_right_corner.svg
    sed -i "s/#FE0000/${accent_color}/g" svg/original/circle.svg
    sed -i "s/#5F3BE4/${accent_color}/g" svg/original/context-menu.svg
    sed -i "s/#06B231/${accent_color}/g" svg/original/copy.svg
    sed -i "s/#FE0000/${background_color}/g" svg/original/crossed_circle.svg
    sed -i "s/#FE0000/${outline_color}/g" svg/original/crosshair.svg
    sed -i "s/#F27400/${accent_color}/g" svg/original/dnd-ask.svg
    sed -i "s/#06B231/${accent_color}/g" svg/original/dnd-copy.svg
    sed -i "s/#606060/${accent_color}/g" svg/original/dnd-link.svg
    sed -i "s/#FE0000/${accent_color}/g" svg/original/dnd_no_drop.svg
    sed -i "s/#606060/${accent_color}/g" svg/original/link.svg
    sed -i "s/#2C2C2C/${accent_color}/g" svg/original/person.svg
    sed -i "s/#0A6857/${accent_color}/g" svg/original/pin.svg
    sed -i "s/#179DD8/${accent_color}/g" svg/original/pointer-move.svg
    sed -i "s/#4FADDF/${background_color}/g" svg/original/top_left_corner.svg
    sed -i "s/#F1613A/${background_color}/g" svg/original/top_right_corner.svg
  '';
}
