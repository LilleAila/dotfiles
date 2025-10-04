{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.settings.minecraft;

  secrets = import ../../secrets/minecraft.nix;
in
{
  options.settings.minecraft = {
    enable = lib.mkEnableOption "minecraft server";
  };

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    settings.nix.unfree = [
      "minecraft-server"
    ];

    # services.caddy.virtualHosts."minecraft.olai.dev".extraConfig = ''
    #   reverse_proxy http://127.0.0.1:25565
    # '';

    # services.caddy.virtualHosts."minecraft-console.olai.dev".extraConfig = ''
    #   reverse_proxy http://127.0.0.1:25575
    # '';

    # TODO. does not work.
    # services.caddy.globalConfig = ''
    #   layer4 {
    #       :25565 {
    #         route {
    #             @minecraft_sni tls {
    #                 sni minecraft.olai.dev
    #             }
    #
    #             route @minecraft_sni {
    #                 proxy localhost:25566
    #             }
    #
    #             route {
    #                 proxy localhost:25566
    #             }
    #         }
    #     }
    #
    #   }
    # '';

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        server1 = {
          enable = true;
          enableReload = true; # Reload rather than restart on config change

          package = pkgs.minecraftServers.fabric-1_21_9-pre4;

          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {
                # TODO https://github.com/henkelmax/hermitcraft-server
                # (or maybe a variation of it idk)
              }
            );
          };

          inherit (secrets) whitelist operators;

          serverProperties = {
            # https://minecraft.wiki/w/Server.properties
            port = 25565;
            gamemode = "survival";
            difficulty = "hard";
            motd = "Veldig gøy server!!";
            white-list = true;

            enable-rcon = true;
            "rcon.password" = secrets.rcon-password;
            "rcon.port" = 25575;
          };
        };
      };
    };
  };
}
