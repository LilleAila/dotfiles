{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.settings.minecraft;
in
{
  options.settings.minecraft = {
    enable = lib.mkEnableOption "minecraft server";
  };

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.caddy.virtualHosts."minecraft.olai.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:25565
    '';

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        server1 = {
          enable = true;
          enableReload = true; # Reload rather than restart on config change

          package = pkgs.minecraftServers.fabric-1_21_9;
          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {
                # TODO https://github.com/henkelmax/hermitcraft-server
                # (or maybe a variation of it idk)
              }
            );
          };

          # NOTE: maybe all of this should be left imperative (unset)?
          whitelist = {
            # TODO
          };
          operators = {
            # TODO
          };
          serverProperties = {
            # TODO
            port = 25565;
            gamemode = "survival";
            difficulty = "hard";
            motd = "Veldig gøy server!!";
            white-list = true;
            enable-rcon = true;
            rcon.password = "abc"; # TODO
          };
        };
      };
    };
  };
}
