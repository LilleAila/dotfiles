{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./wm
    ./programs
  ];
}
