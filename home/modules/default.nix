{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./shell
    ./desktop
    ./system
  ];
}
