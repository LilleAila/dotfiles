{ lib, inputs, ... }:
{
  flake.modules.homeManager.plover =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.settings.plover;
      package = inputs.plover-flake.packages.${pkgs.system}.plover.withPlugins (
        ps: with ps; [
          plover-lapwing-aio
        ]
      );
    in
    {
      options.settings.plover = {
        enable = lib.mkEnableOption "plover";
        package = lib.mkOption {
          type = lib.types.package;
          default = package;
          internal = true;
        };
      };

      imports = [
        inputs.plover-flake.homeManagerModules.plover
      ];

      config = lib.mkIf config.settings.plover.enable {
        programs.plover = {
          enable = true;
          inherit (cfg) package;
        };
      };
    };
}
