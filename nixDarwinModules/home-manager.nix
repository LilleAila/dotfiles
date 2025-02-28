{
  config,
  lib,
  inputs,
  user,
  globalSettings, # again, compatibility. will be refactored later
  outputs,
  keys,
  stablePkgs,
  ...
}:
{
  options.settings.home-manager.enable = lib.mkEnableOption "home-manager";

  imports = [
    inputs.home-manager.darwinModules.home-manager
    (lib.mkAliasOptionModule
      [ "hm" ]
      [
        "home-manager"
        "users"
        user
      ]
    )
  ];

  config = lib.mkIf config.settings.home-manager.enable {
    users.users.${user}.home = "/Users/${user}";
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit
          inputs
          stablePkgs
          outputs
          globalSettings
          keys
          lib
          user
          ;
        isNixOS = false;
      };
      backupFileExtension = "hm-backup";
    };

    # Just a list of the options so that it compiles properly
    # These do not do anything on darwin, but have to be present
    hm.options.settings = {
      persist = {
        home = {
          directories = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Directories to persist in home directory";
          };
          files = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Files to persist in home directory";
          };
          cache = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Directories to persist, but not to snapshot";
          };
          cache_files = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Files to persist in home directory, but not to snapshot";
          };
        };
      };
    };
  };
}
