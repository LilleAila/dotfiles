{ lib, ... }:
{
  flake.modules.nixos.docker =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings.docker.enable = lib.mkEnableOption "docker";

      config = lib.mkIf config.settings.docker.enable {
        virtualisation.docker = {
          enable = true;
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
          daemon = {
            settings = {
              data-root = "/var/lib/docker";
            };
          };
        };

        settings.persist.root.cache = [ "/var/lib/docker" ];

        # users.users.${config.settings.user.name}.extraGroups = [ "docker" ];
      };
    };
}
