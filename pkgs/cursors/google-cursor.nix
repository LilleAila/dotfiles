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
  extra_commands = ''
    sed -i "s/white/${outline_color}/g" svg/animated/wait.svg
    sed -i "s/#8c382a/${background_color}/g" svg/animated/wait.svg
    sed -i "s/#c5523f/${accent_color}/g" svg/animated/wait.svg

    sed -i "s/white/${outline_color}/g" svg/animated/left_ptr_watch.svg
    sed -i "s/#8c382a/${background_color}/g" svg/animated/left_ptr_watch.svg
    sed -i "s/#c5523f/${accent_color}/g" svg/animated/left_ptr_watch.svg

    sed -i "s/#FC3C36/${accent_color}/g" svg/static/zoom-out.svg
    sed -i "s/#00D161/${accent_color}/g" svg/static/zoom-in.svg
  '';
}
