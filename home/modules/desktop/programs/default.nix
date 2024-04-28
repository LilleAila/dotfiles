{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./ags
    ./discord
    ./emacs
    ./fcitx5
    ./firefox
    ./misc
    ./qutebrowser
    ./terminal
    ./webapps
  ];
}
