{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.modules.nixos.minecraft =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.settings.minecraft;

      secrets = self.secrets.minecraft;
    in
    {
      options.settings.minecraft = {
        enable = lib.mkEnableOption "minecraft server";
        preset = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.enum [
              "oci"
              "desktop"
            ]
          );
          default = null;
        };
      };

      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          (lib.mkIf (cfg.preset == "desktop") {
            networking.firewall.allowedTCPPorts = [ 24454 ];
            networking.firewall.allowedUDPPorts = [ 24454 ];

            services.minecraft-servers.servers = {
              # proxy = {
              #   enable = true;
              #   package =
              #     inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.velocityServers.velocity;
              #
              #   files = {
              #     "forwarding.secret" = pkgs.writeText "forwarding.secret" secrets.forwarding-secret;
              #
              #     "velocity.toml".value = {
              #       bind = "0.0.0.0:25565";
              #       forwarding-mode = "modern";
              #       player-info-forwarding-mode = "modern";
              #
              #       online-mode = true;
              #       force-key-authentication = true;
              #       prevent-client-proxy-connections = false;
              #       ping-passthrough = "all";
              #
              #       forwarding-secret-file = "forwarding.secret";
              #
              #       motd = "The server is offline :(";
              #       show-max-players = 67;
              #
              #       servers = {
              #         create = "127.0.0.1:30001";
              #         minecraft2 = "127.0.0.1:30002";
              #
              #         try = [
              #           "minecraft2"
              #           "create"
              #         ];
              #       };
              #
              #       forced-hosts = {
              #         "create.olai.dev" = [ "create" ];
              #         "minecraft2.olai.dev" = [ "minecraft2" ];
              #       };
              #     };
              #   };
              # };

              minecraft2 = {
                enable = true;

                package = pkgs.minecraftServers.fabric-26_3.override {
                  jre_headless = pkgs.jdk25_headless;
                };

                symlinks = {
                  mods =
                    let
                      inherit (pkgs) fetchurl;
                    in
                    pkgs.linkFarmFromDrvs "mods" (
                      builtins.attrValues {
                        # Required mods for server
                        # FabricProxy-Lite = fetchurl {
                        #   url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/nR8AIdvx/FabricProxy-Lite-2.11.0.jar";
                        #   sha512 = "c2e1d9279f6f19a561f934b846540b28a033586b4b419b9c1aa27ac43ffc8fad2ce60e212a15406e5fa3907ff5ecbe5af7a5edb183a9ee6737a41e464aec1375";
                        # };

                        # datapack-injector = fetchurl {
                        #   url = "https://cdn.modrinth.com/data/9nFfpUyI/versions/CeZQK2mE/datapack-injector-fabric-1.0.0%2B1.21.9.jar";
                        #   sha512 = "4301d9666d52a9abf84f6367f066712fc775bc2028a62fa7fe2335744cc2fffb3609b0fffbe9a3d38492c095a06a8bce3cdc002481882ead9fbbfe827c423a94";
                        # };

                        # Libs
                        Fabric-API = fetchurl {
                          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/EQKgpeKu/fabric-api-0.165.0%2B26.3.jar";
                          sha512 = "0a4b8a14e847b71567b557b43d906c2167fa263eeeef37454a821ba286996e3da1616dc2d9647736d28a250d5ecf400541cae808359b29a62324a8a6f2ad5e30";
                        };

                        # Lithostitched = fetchurl {
                        #   url = "https://cdn.modrinth.com/data/XaDC71GB/versions/pZgI6b2t/lithostitched-2.0.6-fabric-26.3.jar";
                        #   sha512 = "d7ffe9bb3ea653ae70317f8621c546e3331369c0dd3cd6cadb374cc71283ca1fae1e7de7d2d16eb5724e96f7159c8b043e15a618f32dad88c8e70a7d8d1db4ee";
                        # };

                        # QOL mods
                        # Simple-Voice-Chat = fetchurl {
                        #   url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/pTfXZIdn/voicechat-fabric-1.21.9-2.6.4.jar";
                        #   sha512 = "234e5dbbad40a56546c5897995b9ac81bac11fa7478537f02e55a555af261783947b9695a5eb476173c0534248a46bb78040de16d4b831c4fc500c0406ac4e2a";
                        # };

                        Lithium = fetchurl {
                          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/xS0Q8LSi/lithium-fabric-0.26.2%2Bmc26.3.jar";
                          sha512 = "4d7fee66132eedc71feab9390b92c95d7058edbdad0fecfac1d836a2950b97a7ca463afbede61c7ef361ce65e1f927ab9e89dde5bf2e0e0ce486afb5c5dbee40";
                        };

                        FerriteCore = fetchurl {
                          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
                          sha512 = "d81fa97e11784c19d42f89c2f433831d007603dd7193cee45fa177e4a6a9c52b384b198586e04a0f7f63cd996fed713322578bde9a8db57e1188854ae5cbe584";
                        };

                        Krypton = fetchurl {
                          url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/UugdIYJw/krypton-0.3.2.jar";
                          sha512 = "d1d57ebd41395b75b01f130cd9503eb8d208212424a399ff9f367f50be8fbc1c6472442b33c686e777c3148f6a609520e8fb732c755157c358cb207fd4d1123a";
                        };

                        # Other stuff
                        # Terralith = fetchurl {
                        #   url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/aGE3hYAA/Terralith_26.3_v2.6.5%2B26.3.jar";
                        #   sha512 = "918b232df7a855bae89c7fa85affb5ce134e236c4726fa14a5bdaa179eb1e010f040a9fa981f006a0e26e421a2a961bc29a75e99a4500fd18361a8ba81478071";
                        # };
                      }
                    );
                };

                files = {
                  # "config/FabricProxy-Lite.toml".value = {
                  #   secret = secrets.forwarding-secret;
                  # };

                  # datapacks = pkgs.buildEnv {
                  #   name = "minecraft-datapacks";
                  #   paths = [
                  #     # https://vanillatweaks.net/share#7fcThl
                  #     (pkgs.fetchzip {
                  #       url = "https://vanillatweaks.net/download/VanillaTweaks_d828028_UNZIP_ME.zip";
                  #       sha256 = "sha256-jN9hCkh3Hh6+7YWjtIJs4wuZCQV3s+PsXxiUuM+f1h0=";
                  #       stripRoot = false;
                  #     })
                  #   ];
                  # };
                };

                inherit (secrets.minecraft2) whitelist operators;

                serverProperties = {
                  gamemode = "survival";
                  difficulty = "hard";
                  motd = "minecraft server ig";
                  white-list = true;
                  level-seed = "5890542";
                  spawn-protection = 0;

                  enable-rcon = true;
                  "rcon.password" = secrets.rcon-password;
                  "rcon.port" = 25576;

                  server-port = 25565;
                  # Proxy broken, bypassing instead
                  # server-port = 30002;
                  # online-mode = false;
                  # server-ip = "127.0.0.1";
                };
              };

              # create = {
              #   NOTE: imperative changes done in /srv/minecraft/create/config:
              #   Disable creeper, enderman and ghast in moremobgriefingoptions-server.toml
              #   Disable attempt_udp_networking in sable-common.toml
              #   enable = true;
              #   package = pkgs.neoforgeServers.neoforge-1_21_1;
              #
              #   jvmOpts = "-Xms6144M -Xmx8192M";
              #
              #   symlinks.mods = import ./_create_mods.nix pkgs;
              #
              #   files = {
              #     "config/proxy-compatible-forge.toml".value = {
              #       forwarding.secret = secrets.forwarding-secret;
              #     };
              #
              #     "config/voicechat/voicechat-server.properties".value = {
              #       port = 24454;
              #     };
              #   };
              #
              #   inherit (secrets.create) whitelist operators;
              #
              #   serverProperties = {
              #     # https://minecraft.wiki/w/Server.properties
              #     gamemode = "survival";
              #     difficulty = "hard";
              #     motd = "Create server";
              #     white-list = true;
              #     view-distance = 12;
              #
              #     enable-rcon = true;
              #     "rcon.password" = secrets.rcon-password;
              #     "rcon.port" = 25575;
              #
              #     # To use with proxy:
              #     server-port = 3001;
              #     online-mode = false;
              #     server-ip = "127.0.0.1";
              #   };
              # };
            };
          })
          (lib.mkIf (cfg.preset == "oci") {
            services.minecraft-servers.servers = {
              proxy = {
                enable = true;
                package =
                  inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.velocityServers.velocity;

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
                      server1 = "127.0.0.1:30001";
                      ghserver = "127.0.0.1:30002";

                      try = [ "ghserver" ];
                    };

                    forced-hosts = {
                      "minecraft.olai.dev" = [ "server1" ];
                      "thederivativeofgparenthesisandhcoalitionminecraftserver.olai.dev" = [ "ghserver" ];
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

                      # TODO: vanilla tweaks https://vanillatweaks.net/share#Z4MSlG
                      # datapack-injector = pkgs.fetchurl {
                      #   url = "https://cdn.modrinth.com/data/9nFfpUyI/versions/CeZQK2mE/datapack-injector-fabric-1.0.0%2B1.21.9.jar";
                      #   sha512 = "4301d9666d52a9abf84f6367f066712fc775bc2028a62fa7fe2335744cc2fffb3609b0fffbe9a3d38492c095a06a8bce3cdc002481882ead9fbbfe827c423a94";
                      # };
                    }
                  );
                };

                files = {
                  "config/FabricProxy-Lite.toml".value = {
                    secret = secrets.forwarding-secret;
                  };

                  "config/voicechat/voicechat-server.properties".value = {
                    port = 24454;
                  };
                };

                inherit (secrets.server1) whitelist operators;

                serverProperties = {
                  # https://minecraft.wiki/w/Server.properties
                  gamemode = "survival";
                  difficulty = "hard";
                  motd = "Veldig gøy server!!";
                  white-list = true;
                  view-distance = 12;

                  enable-rcon = true;
                  "rcon.password" = secrets.rcon-password;
                  "rcon.port" = 25575;

                  # To use with proxy:
                  server-port = 30001;
                  online-mode = false;
                  server-ip = "127.0.0.1";
                };
              };

              ghserver = {
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

                      datapack-injector = pkgs.fetchurl {
                        url = "https://cdn.modrinth.com/data/9nFfpUyI/versions/CeZQK2mE/datapack-injector-fabric-1.0.0%2B1.21.9.jar";
                        sha512 = "4301d9666d52a9abf84f6367f066712fc775bc2028a62fa7fe2335744cc2fffb3609b0fffbe9a3d38492c095a06a8bce3cdc002481882ead9fbbfe827c423a94";
                      };
                    }
                  );
                };

                files = {
                  "config/FabricProxy-Lite.toml".value = {
                    secret = secrets.forwarding-secret;
                  };

                  "config/voicechat/voicechat-server.properties".value = {
                    port = 24455;
                  };

                  datapacks = pkgs.buildEnv {
                    name = "minecraft-datapacks";
                    paths = [
                      # https://vanillatweaks.net/share#7fcThl
                      (pkgs.fetchzip {
                        url = "https://vanillatweaks.net/download/VanillaTweaks_d828028_UNZIP_ME.zip";
                        sha256 = "sha256-jN9hCkh3Hh6+7YWjtIJs4wuZCQV3s+PsXxiUuM+f1h0=";
                        stripRoot = false;
                      })
                      # (pkgs.runCommand "touch_grass_zip" { } ''
                      #   mkdir -p $out
                      #   cd ${./datapacks/touch_grass}
                      #   ${lib.getExe pkgs.zip} -r $out/touch_grass.zip ./*
                      # '')
                    ];
                  };
                };

                inherit (secrets.ghserver) whitelist operators;

                serverProperties = {
                  gamemode = "survival";
                  difficulty = "hard";
                  motd = "The G' (and H) coalition";
                  white-list = true;

                  enable-rcon = true;
                  "rcon.password" = secrets.rcon-password;
                  "rcon.port" = 25576;

                  server-port = 30002;
                  online-mode = false;
                  server-ip = "127.0.0.1";
                };
              };
            };
          })
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
            environment.systemPackages = [
              inputs.nix-minecraft.packages.${pkgs.stdenv.hostPlatform.system}.nix-modrinth-prefetch
            ];

            settings.nix.unfree = [
              "minecraft-server"
              "neoforge"
            ];

            settings.persist.root.directories = [
              "/srv/minecraft"
              "/srv/backups"
            ];

            networking.firewall.allowedTCPPorts = [ 25565 ]; # Velocity
            networking.firewall.allowedUDPPorts = [ 25565 ]; # Velocity (voice chat)

            services.minecraft-servers = {
              enable = true;
              eula = true;
              openFirewall = false;

              servers = {
                # TODO: automatically proxy server with name x to x.olai.dev rather than hard code
              };
            };
          }
        ]
      );
    };
}
