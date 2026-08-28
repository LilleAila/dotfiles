{ self, lib, ... }:
{
  flake.modules.nixos.factorio =
    { config, user, ... }:
    let
      cfg = config.settings.factorio;
    in
    {
      options.settings.factorio.enable = lib.mkEnableOption "factorio";

      config = lib.mkIf cfg.enable {
        services.factorio = {
          enable = true;
          openFirewall = true;
          requireUserVerification = false;
          inherit (self.secrets.factorio.server) game-password allowedPlayers admins;
        };

        users.users.factorio = {
          isSystemUser = true;
          group = "factorio";
          home = "/var/lib/factorio";
          createHome = false;
        };
        users.groups.factorio = { };

        # NOTE: imperatively disabled space-age in modlist
        # If i want to create multiple factorio servers in the future,
        # it may actually be easier to just write my own module system for it
        systemd.services.factorio = {
          serviceConfig = {
            DynamicUser = lib.mkForce false;
            User = "factorio";
            Group = "factorio";
          };

          # preStart =
          #   let
          #     cfg = config.services.factorio;
          #     stateDir = "/var/lib/${cfg.stateDirName}";
          #     mkSavePath = name: "${stateDir}/saves/${name}.zip";
          #
          #   in
          #   toString [
          #     "test -e ${stateDir}/saves/${cfg.saveName}.zip"
          #     "||"
          #     "${cfg.package}/bin/factorio"
          #     "--config=${cfg.configFile}"
          #     "--create=${mkSavePath cfg.saveName}"
          #     "--mod-directory=${stateDir}/mods"
          #   ];
        };

        settings.nix.unfree = [ "factorio-headless" ];

        environment.persistence."/persist".directories = [
          {
            directory = "/var/lib/${config.services.factorio.stateDirName}";
            user = "factorio";
            group = "factorio";
            mode = "0774";
          }
        ];

        # settings.persist.root.directories = [
        #   "/var/lib/${config.services.factorio.stateDirName}"
        # ];
      };
    };
}
