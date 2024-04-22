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
  extra_commands = ''
    sed -i "s/#3DAEE9/${accent_color}/g" svg/static/question_arrow.svg
    sed -i "s/#ED1515/${accent_color}/g" svg/static/crossed_circle.svg
    sed -i "s/#ED1515/${accent_color}/g" svg/static/dnd_no_drop.svg
    sed -i "s/#11D116/${accent_color}/g" svg/static/copy.svg
    sed -i "s/#F67400/${accent_color}/g" svg/static/all-scroll.svg
    sed -i "s/#18A0FB/${accent_color}/g" svg/static/bd_double_arrow.svg
    sed -i "s/#18A0FB/${accent_color}/g" svg/static/fd_double_arrow.svg
    sed -i "s/#18A0FB/${accent_color}/g" svg/static/sb_h_double_arrow.svg
    sed -i "s/#18A0FB/${accent_color}/g" svg/static/sb_v_double_arrow.svg
    sed -i "s/#3DAEE9/${accent_color}/g" svg/static/context-menu.svg
    sed -i "s/#18C087/${accent_color}/g" svg/static/link.svg
    sed -i "s/#ED1515/${accent_color}/g" svg/static/pirate.svg
    sed -i "s/#2EAFBB/${accent_color}/g" svg/static/wayland-cursor.svg
    sed -i "s/#2C2F78/${accent_color}/g" svg/static/wayland-cursor.svg
    sed -i "s/#F7A61F/${accent_color}/g" svg/static/X_cursor.svg
    sed -i "s/#EF6501/${accent_color}/g" svg/static/X_cursor.svg
  '';
}
