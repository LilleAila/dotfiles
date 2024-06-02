{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  globalSettings,
  keys,
  ...
}: {
  options.settings.home-manager.enable = lib.mkDisableOption "home-manager";
  options.settings.home-manager.path = lib.mkOption {
    type = lib.types.path;
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" globalSettings.username])
  ];

  config = lib.mkIf config.settings.home-manager.enable (lib.mkMerge [
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs outputs globalSettings keys lib;
          isNixOS = true;
        };
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        users."${globalSettings.username}" = config.settings.home-manager.path;
      };
    }
  ]);
}
