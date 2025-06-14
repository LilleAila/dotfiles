{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.settings.plover.enable = lib.mkEnableOption "plover";

  imports = [
    inputs.plover-flake.homeManagerModules.plover
  ];

  config = lib.mkIf config.settings.plover.enable {
    programs.plover = {
      enable = true;
      package = inputs.plover-flake.packages.${pkgs.system}.plover.withPlugins (
        ps: with ps; [
          plover-lapwing-aio
        ]
      );
    };
  };
}
