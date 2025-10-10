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
    environment.systemPackages = [
      inputs.nix-minecraft.packages.${pkgs.system}.nix-modrinth-prefetch
    ];

    settings.nix.unfree = [
      "minecraft-server"
    ];

    networking.firewall.allowedTCPPorts = [ 25565 ]; # Velocity
    networking.firewall.allowedUDPPorts = [ 25565 ]; # Velocity (voice chat)

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = false;

      servers = {
        # TODO: automatically proxy server with name x to x.olai.dev rather than hard code
        proxy = {
          enable = true;
          package = inputs.nix-minecraft.legacyPackages.${pkgs.system}.velocityServers.velocity;

          files = {
            "forwarding.secret" = pkgs.writeText "forwarding.secret" secrets.forwarding-secret;

            "velocity.toml".value = {
              bind = "0.0.0.0:25565";
              forwarding-mode = "modern";
              player-info-forwarding-mode = "modern";

              online-mode = true;
              force-key-authentication = true;
              prevent-client-proxy-connections = false;
              ping-passthrough = "all";

              forwarding-secret-file = "forwarding.secret";

              motd = "The server is offline :(";
              show-max-players = 67;

              servers = {
                main = "127.0.0.1:30001";

                try = [ "main" ];
              };

              forced-hosts = {
                "minecraft.olai.dev" = [ "main" ];
              };
            };

            "plugins/voicechat.jar" = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/jMopHMDQ/voicechat-velocity-2.6.4.jar";
              sha512 = "03db44bdcf8012fdd7c93ce94c3fe37506d6cd39084ac9fcc294a9069d8bc5f9f160423b67af6a43b2fe044e4df9e716fd8b27fe61f404f94bda71556cc21ebc";
            };
          };
        };

        server1 = {
          enable = true;

          package = pkgs.minecraftServers.fabric-1_21_9;

          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {
                # Required mods for server
                FabricProxy-Lite = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/nR8AIdvx/FabricProxy-Lite-2.11.0.jar";
                  sha512 = "c2e1d9279f6f19a561f934b846540b28a033586b4b419b9c1aa27ac43ffc8fad2ce60e212a15406e5fa3907ff5ecbe5af7a5edb183a9ee6737a41e464aec1375";
                };

                Fabric-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/iHrvVvaM/fabric-api-0.134.0%2B1.21.9.jar";
                  sha512 = "6f2c8d7aa311b90af2d80a4a9de18f22e3a19ebe22cf115278eabd3d397725bc706e98827c9eed20f9d751d4701e1da1cdf7258b90f77e65148a7a0133a1e336";
                };

                # QOL mods
                Simple-Voice-Chat = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/pTfXZIdn/voicechat-fabric-1.21.9-2.6.4.jar";
                  sha512 = "234e5dbbad40a56546c5897995b9ac81bac11fa7478537f02e55a555af261783947b9695a5eb476173c0534248a46bb78040de16d4b831c4fc500c0406ac4e2a";
                };

                # TODO https://github.com/henkelmax/hermitcraft-server
                # (or maybe a variation of it idk)
              }
            );
          };

          files = {
            "config/FabricProxy-Lite.toml".value = {
              secret = secrets.forwarding-secret;
            };
          };

          inherit (secrets) whitelist operators;

          serverProperties = {
            # https://minecraft.wiki/w/Server.properties
            gamemode = "survival";
            difficulty = "hard";
            motd = "Veldig gøy server!!";
            white-list = true;

            enable-rcon = true;
            "rcon.password" = secrets.rcon-password;
            "rcon.port" = 25575;

            # To use with proxy:
            server-port = 30001;
            online-mode = false;
            server-ip = "127.0.0.1";
          };
        };
      };
    };
  };
}
