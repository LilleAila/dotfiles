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
    #     :25566 {
    #       route {
    #         proxy {
    #           upstream 127.0.0.1:25565
    #         }
    #       }
    #     }
    #   }
    # '';

    # services.caddy.virtualHosts."minecraft.olai.dev:25565".extraConfig = ''
    #   reverse_proxy http://127.0.0.1:25565
    # '';

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        # velocity = {
        #   enable = true;
        #   package = inputs.nix-minecraft.legacyPackages.${pkgs.system}.velocityServers.velocity;
        #
        #   symlinks."velocity.toml" = pkgs.writeText "velocity.toml" ''
        #     bind = "0.0.0.0:25565"
        #     motd = "Server"
        #     forwarding-mode = "modern"
        #
        #     [servers]
        #     main = "127.0.0.1:300001"
        #
        #     try = [
        #       "main"
        #     ]
        #
        #     [forced-hosts]
        #     minecraft.olai.dev = [ "main" ]
        #   '';
        # };

        server1 = {
          enable = true;
          enableReload = true; # Reload rather than restart on config change

          package = pkgs.minecraftServers.fabric-1_21_9-pre4;

          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {
                # FabricProxy-Lite = pkgs.fetchurl {
                #   url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/nR8AIdvx/FabricProxy-Lite-2.11.0.jar";
                #   sha512 = "c2e1d9279f6f19a561f934b846540b28a033586b4b419b9c1aa27ac43ffc8fad2ce60e212a15406e5fa3907ff5ecbe5af7a5edb183a9ee6737a41e464aec1375";
                # };

                # TODO https://github.com/henkelmax/hermitcraft-server
                # (or maybe a variation of it idk)
              }
            );
          };

          inherit (secrets) whitelist operators;

          serverProperties = {
            # https://minecraft.wiki/w/Server.properties
            server-port = 30001;
            online-mode = false;
            server-ip = "127.0.0.1";

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
