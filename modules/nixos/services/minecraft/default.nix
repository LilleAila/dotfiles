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
            services.minecraft-servers.servers = {
              proxy.files."velocity.toml".value = {
                servers = {
                  create = "127.0.0.1:30001";

                  try = [ "create" ];
                };

                forced-hosts = {
                  "create.olai.dev" = [ "create" ];
                };
              };

              create = {
                enable = true;
                package = pkgs.neoforgeServers.neoforge-1_21_1;

                jvmOpts = "-Xms6144M -Xmx8192M";

                symlinks = {
                  mods =
                    let
                      inherit (pkgs) fetchurl;
                    in
                    pkgs.linkFarmFromDrvs "mods" (
                      builtins.attrValues {
                        Proxy-Compatible-Forge = fetchurl {
                          url = "https://cdn.modrinth.com/data/vDyrHl8l/versions/iRclYdm8/proxy-compatible-forge-1.2.6.jar";
                          sha512 = "de48f409c0f780217a257dc5b7196fef5e930703b513ac93f58658f1db0d3c002ba8ee687ead90b1692557aee3cd68095f8860370460edd446faf307a8df485b";
                        };

                        Create = fetchurl {
                          url = "https://cdn.modrinth.com/data/LNytGWDc/versions/UjX6dr61/create-1.21.1-6.0.10.jar";
                          sha512 = "11cc8fc049d2f67f6548c7abfada6b82a3adb5c7ca410a742de04bbca76e03862c518721b88d806f6e6d768a4d68531fdb903a85859b25d1484d550cc7bafd4b";
                        };

                        Create-Aeronautics = fetchurl {
                          url = "https://cdn.modrinth.com/data/oWaK0Q19/versions/YhZLrAFC/create-aeronautics-bundled-1.21.1-1.2.1.jar";
                          sha512 = "c7899f8a693cf1b4c17a31faf64e631383f6df331b82b517ed6abe01b0464a9f10b226f0336fa8611c5af514375716c4d009d55c7f92640445c68239b63ebc03";
                        };

                        Create-Radars = fetchurl {
                          url = "https://cdn.modrinth.com/data/BLu2Yqfq/versions/3MbtX7qD/create_radar-0.4.8-1.21.1.jar";
                          sha512 = "d739365d6d46cd7ced5a4731b2c424c1d0585ad5201b7ca7b5be488c7edf3ac51b67091bb61c121e4836b10959cf5733c017fa3a979ef89d0f8a872f4eca8441";
                        };

                        Vista = fetchurl {
                          url = "https://cdn.modrinth.com/data/zuARv1N7/versions/vn6oQ1z1/vista-neoforge-1.21.1-4.4.8.jar";
                          sha512 = "e001ef38d0e242d3e3b8379a1611819fe0a3544f4fd8e14757e75c72890e76a86b05c7de92acd5976cce5e91c8088b27da78fd7b9b35e44045cc31987560ccd9";
                        };

                        Vista-Aeronautics-Fix = fetchurl {
                          url = "https://cdn.modrinth.com/data/ayWsj31j/versions/q4MJ1X5o/VistaAeronauticsFix-1.0.0.jar";
                          sha512 = "61604de7d7976335b6a6dda63be04218883811562fd1e70ef030bff7be7a621c69f7a20e50087d995194478983c0ecd79791bbea2812192615e22a171b0720ac";
                        };

                        Sable = fetchurl {
                          url = "https://cdn.modrinth.com/data/T9PomCSv/versions/3FMsUjO4/sable-neoforge-1.21.1-1.2.2.jar";
                          sha512 = "eb7c46649f5aa359f688fecacfa348b205dff0cfc2d27694632c2e1e1f8f4dbab2c31bdc95b2577201529b2597afe49328c7ad8c348d25eaca109f1a02667534";
                        };

                        Copycats-Aeronautics-Weight = fetchurl {
                          url = "https://cdn.modrinth.com/data/wjpmYU1u/versions/wsXjRa7l/aerocopycats-1.1.1.jar";
                          sha512 = "4f48c03a25a6f4ec022398cece20e5aa8d51f00951a0f568980e6e5419c1af2f12c8bb652500721afef119ecc455e4c5b1bc4bb7bef38d88846759f0e4c39e8c";
                        };

                        Create-Copycats = fetchurl {
                          url = "https://cdn.modrinth.com/data/UT2M39wf/versions/kecZ0sl7/copycats-3.0.4%2Bmc.1.21.1-neoforge.jar";
                          sha512 = "ecc98e659be66a71af0aee66a9f4c7c8838f4f0101402644929079ce7280a572a000e7e417905e1869a51d6e49ebbd601008f54585e07ee4ed01f2c4bc752bfe";
                        };

                        # NOTE: not on modrinth - used curseforge. not sure of stability
                        Create-Copycats-Weight = fetchurl {
                          url = "https://www.curseforge.com/api/v1/mods/1530305/files/8020405/download";
                          sha256 = "1yb42assr6k11g91fzbz8pkahlz68zn8xyafdh4s7w9xfmv1rya0";
                        };

                        Create-Aeroworks = fetchurl {
                          url = "https://cdn.modrinth.com/data/P26k79kP/versions/LKsY0cFi/aeroworks-1.2.9.jar";
                          sha512 = "3713a65a8c76f7c59c62a0d4015bd923b9c6179f3b475422ee44b69b58487ec4550debcc8c583db701a8d3cf0dc79cd3976cff959ddf8149c1fc1cb3b9ee7746";
                        };

                        Create-Propulsion-Simulated = fetchurl {
                          url = "https://cdn.modrinth.com/data/ApkoHNO9/versions/hTnJ29I0/createpropulsion-1.1.4.jar";
                          sha512 = "25e9655b6e44ee5539f2b3b620d8657f3b9f0cb840a0917d4bb5e349b5fb301bb15a05e420122cdc2f9236fc9b78019d98816e3f3d939dabf6c5c1b05e6b6862";
                        };

                        Create-Central-Kitchen = fetchurl {
                          url = "https://cdn.modrinth.com/data/btq68HMO/versions/TUJIHmUh/create-central-kitchen-2.4.0.jar";
                          sha512 = "adcdb5a85b2dd727fa2b0563aa9e73d26b58ee3ae57192e049f0c2a1e4a878dc9d07fe20589f6e52e6f4be2ba1bb5ab3a64f5fcf5f1f9a42b9518e7c2380fd23";
                        };

                        Create-Nuclear = fetchurl {
                          url = "https://cdn.modrinth.com/data/z611fdf7/versions/waO2BSHO/createnuclear-1.3.2-beta.3-neoforge.jar";
                          sha512 = "39d9691d8f00f375a438193139c30fe60032cf04cd99d83fa428fefef5c8ed79d49d8f09b5f0e57fb4b2c4058fc4c2bad942a0913dd885f701a5e9f0d9d2f36f";
                        };

                        Create-Connected = fetchurl {
                          url = "https://cdn.modrinth.com/data/Vg5TIO6d/versions/EHyCRpCV/create_connected-1.1.16-mc1.21.1.jar";
                          sha512 = "75feee95543d8b4e077ff40d5abd39a7a14035c1ebce7cfa4875df909de77c52137217a5de49a4ef5127a7e9c615232e15b9299d49cb56f08e4128dcfc07b94e";
                        };

                        Create-Power-Grid = fetchurl {
                          url = "https://cdn.modrinth.com/data/eWiBLJ9R/versions/8EtGIOFr/powergrid-mc1.21.1-0.5.5.1.jar";
                          sha512 = "0dafe82438143270a762f9bfff3483c56e85a5db0bb382dba15302b6d6f6a886f252dee42fca08fb46c7a76eb9401f90430d41994b20133e9c009d5b876b8bb5";
                        };

                        Create-Threaded-Trains = fetchurl {
                          url = "https://cdn.modrinth.com/data/RYJzdkDr/versions/ry1hvo4l/createthreadedtrains-neoforge-1.21.1-1.0.0.jar";
                          sha512 = "93511d32e8c7484fdcfd90646d48f297ba3188788e0ea6412900be38ae6b82e69bc131bbb011519b52ac0728a7dfd531c0ac356a7935335c06f691ad20e38c69";
                        };

                        Create-Extra-Gauges = fetchurl {
                          url = "https://cdn.modrinth.com/data/6YJgomwt/versions/7ogQOYHA/extra_gauges-2.1.2.jar";
                          sha512 = "2ace66647d2077cf6e06cff491a94248f2e611820983acbe36c9acecdce030bce08b98f9461dd67c30f7b0d16cbb7fd7d21dd8dbcf8f0d8411291a8e762d29a7";
                        };

                        Create-Deep-Seas = fetchurl {
                          url = "https://cdn.modrinth.com/data/mva5q4qZ/versions/vt1MWc6K/create_submarine-2.0.3.jar";
                          sha512 = "ff8df5428ef298b5f2a087102d2e5ffad64a941d24c85568124064093adcb8400625633e35de0491b793bad39c80ce591d2f4fa1f13350aa5c73d8bbe3181212";
                        };

                        Create-Big-Cannons = fetchurl {
                          url = "https://cdn.modrinth.com/data/GWp4jCJj/versions/bsGaXKEd/createbigcannons-5.11.3%2Bmc.1.21.1.jar";
                          sha512 = "f75a8bbdc9fc67c09eac6d78e8ad92583a342d54ab70e91923c52cd9b42987765e9a84e43e9c3e175593982aed80fe960a96561d9cd1ed62c4c966818346b466";
                        };

                        Create-Blocks-Bogies = fetchurl {
                          url = "https://cdn.modrinth.com/data/j4ARnQwY/versions/rUu97B0K/create_bb-1.0.7-1.21.1-Neoforge.jar";
                          sha512 = "77741f2b77426bb24607221ea98e544280a81ba74cadb77334c3d0911f8ffbf63d3d3f268d435c1c1e0e5794cfc33f7fbb5fc0e43ba7a89098b4a97aa4396987";
                        };

                        Create-Bits-n-Bobs = fetchurl {
                          url = "https://cdn.modrinth.com/data/T8bvmqVZ/versions/XKDQlGJW/bits_n_bobs-0.0.44.jar";
                          sha512 = "147a2d2067918e8e3a70565c7f9a3a08c7040aedf767d31bc646343d2ef3701e3eab1bb4681a4adde1e8c7f8068daeb3170db575edfbc129fa09718d7ac7bc98";
                        };

                        Create-Numismatics = fetchurl {
                          url = "https://cdn.modrinth.com/data/Jdbbtt0i/versions/guON3qvQ/CreateNumismatics-1.0.20%2Bneoforge-mc1.21.1.jar";
                          sha512 = "2b4ccd516865997735e1a3ec323615bd32d9388e15cc04097ac455f2b453423fccd21969782ecfd031b3de6ed85506ba5349da24c32f5e3eaaf558c5163cf203";
                        };

                        Create-o-Plenty = fetchurl {
                          url = "https://cdn.modrinth.com/data/HgWaxodv/versions/k7AAVyW3/CreateOPlenty-NeoForge-Create%2B6.0.7-3.0.jar";
                          sha512 = "758ef597ea2f1767d6f7a17bc6ea43c3a441b15fb8ff48d2bdcf71a7168f28e903d19c47547ac7fda3a02cd7c324ea7baab8ead18593b17a3799ae15642d77ec";
                        };

                        Alex-Mobs-Unofficial-Port = fetchurl {
                          url = "https://cdn.modrinth.com/data/EmNhnNnt/versions/KSgki4uc/alexsmobs-1.22.17.jar";
                          sha512 = "9f57f20693bb187c54f6d68dc34592b87d0e55a5a4628ad097b0aa39afe165f4a834b83b6590d803e64bac0b1230a8f46369bfe45851a3cc964cf3d88f235277";
                        };

                        Farmers-Delignt = fetchurl {
                          url = "https://cdn.modrinth.com/data/R2OftAxM/versions/GbNuOZ4S/FarmersDelight-1.21.1-1.3.2.jar";
                          sha512 = "da5a4236427df8010d75992201c8723ac84a8fa71efa55670551d333cac94a90ae8e8c536da63ae07a67f4d00dc2774ae4151030f41d26886e508f4a037c8694";
                        };

                        Alex-Delight = fetchurl {
                          # NOTE: curseforge
                          url = "https://www.curseforge.com/api/v1/mods/556448/files/7612806/download";
                          sha256 = "1nsj61426b7f3i4k3xvywzdzpn798qxy9hqbrc8gk6wfmycakay2";
                        };

                        Biomes-o-Plenty = fetchurl {
                          url = "https://cdn.modrinth.com/data/HXF82T3G/versions/8vIRXPpR/BiomesOPlenty-neoforge-1.21.1-21.1.0.13.jar";
                          sha512 = "a238c6dbeccf9bb8f7144601e8f8fd7973d76c60344b50670141e76f49f886f6f89487eb81749dfca7c36166831924052106884a9f8dc18893261476a34d4b32";
                        };

                        Sophisticated-Backpacs = fetchurl {
                          url = "https://cdn.modrinth.com/data/TyCTlI4b/versions/tqDekk0k/sophisticatedbackpacks-1.21.1-3.25.49.1788.jar";
                          sha512 = "230e40869d97e17a4ba01f50c4460087595139baa74ca4e925c391cd3bdbf76b98beff2ca81cc6dc0b7926a59ffd59441e9cc8121fe4b022f2f09a41be80c926";
                        };

                        Rechiseled = fetchurl {
                          url = "https://cdn.modrinth.com/data/B0g2vT6l/versions/b3uurWWs/rechiseled-1.2.4-neoforge-mc1.21.jar";
                          sha512 = "b78f014060b82eea020640a10cc3e774cb355f5289e91191f2f0122eeb4240eac920b3991d10fd1d8628ebf2248322ddf5703117c55783de3d9948fabbd4e2f8";
                        };

                        Corpse = fetchurl {
                          url = "https://cdn.modrinth.com/data/WrpuIfhw/versions/Zwf8nv8y/corpse-neoforge-1.21.1-1.1.13.jar";
                          sha512 = "473aafd82008c1e041e3b4a5a177507d555c8bc9dd1f121f252f1e81bc0c69c79a91cb64be0df343babcb3d4db76efbaa7aa2adaeaae29337808a368bc290ad0";
                        };

                        Corpse-Curios-API-Compat = fetchurl {
                          url = "https://cdn.modrinth.com/data/pJGcKPh1/versions/Ix4uAd2i/corpsecurioscompat-1.21.1-NeoForge-4.0.1.jar";
                          sha512 = "3a75b28b4bf25d775c399c8b5eff1f186020957332f3698d4e313cd0c0785c8b5814ca7fd7194e8b938e276073bab99e8d22aa2c5c10ca78763945db825059fe";
                        };

                        Torchmaster = fetchurl {
                          url = "https://cdn.modrinth.com/data/Tl8ESrhX/versions/PhWXajPC/torchmaster-neoforge-1.21.1-21.1.9.jar";
                          sha512 = "855dd7f37a01c617dddcb5fe569b14a14cff4d5ea7f53a958bec4a694eb4b82677160a2509a84a03e41adea2d44617434667f56f2191e6427811ddbdc63e48fc";
                        };

                        Simple-Voice-Chat = fetchurl {
                          url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/6rT2RWh6/voicechat-neoforge-1.21.1-2.6.17.jar";
                          sha512 = "9646faa446300ee4d34936fdb71614d1e23bc2b3ca8da39a7dc46dc420caa01139db7f9db830154e27ea6662a1a50a68665e09407ba73da45841c3678f1659db";
                        };

                        Clumps = fetchurl {
                          url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/jo7lDoK4/Clumps-neoforge-1.21.1-19.0.0.1.jar";
                          sha512 = "314d8d8e640d73041f27e0f3f2cad7aad8b4c77dbd7fb31700ef7760362261f77085eed5289555c725d99c3f47a114e7290cd608f39c9f0f12ef74958463bdcc";
                        };

                        Jade = fetchurl {
                          url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/yd8FKCmx/Jade-1.21.1-NeoForge-15.10.5.jar";
                          sha512 = "678b998677a3d73f98f82dac4093893bfc8a3c2335ec627b4147811c381a040475decdb8db31cc3cbe600abb5a7a6dedcd356eed0ba471af0becdcf49bf5b137";
                        };

                        Jade-Addons = fetchurl {
                          url = "https://cdn.modrinth.com/data/xuDOzCLy/versions/Z9s9lM56/JadeAddons-1.21.1-NeoForge-6.1.0.jar";
                          sha512 = "dcf1135718e74c55d4b01116c9955b88a8c8a5180e61dc51d292479aff3d2fff38c8ca0f1b4a6e42e54644f1c8907846a61799491df455b71541aa342d8b8896";
                        };

                        Just-Enough-Items = fetchurl {
                          url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/YAcQ6elZ/jei-1.21.1-neoforge-19.27.0.340.jar";
                          sha512 = "8bad8eb3c8e974f867e23e4d74598f603c5fbf03eb5356a386dd37cb9fa23e08ad1f58be6b7be50d2fbf9d3fbfaeac8584c70ced736df4b8f82c7c75be242998";
                        };

                        Polymorph = fetchurl {
                          url = "https://cdn.modrinth.com/data/tagwiZkJ/versions/VEburL70/polymorph-neoforge-1.1.0%2B1.21.1.jar";
                          sha512 = "37358e19d8f251b7d435ea5198eded7b1361e90d5728e11fcb15aeb55786f4ee10fd8fecd14b11f34a99bd92aea01a9977c0dbc46ab6bb07af61a6c89455b6ff";
                        };

                        One-To-One-Nether-Travel = fetchurl {
                          # NOTE: curseforge
                          url = "https://www.curseforge.com/api/v1/mods/1235340/files/6383951/download";
                          sha256 = "1lmif3lbz3782swnb4mxldm5ia60w0l2y1ccnnizlxm0ppp6r44w";
                        };

                        Eternal-Nether = fetchurl {
                          url = "https://cdn.modrinth.com/data/s6R4jmL8/versions/wfHip7bI/EternalNether-v21.1.3-1.21.1-NeoForge.jar";
                          sha512 = "9e01797c9af3b9c4083199342793990ca65e3af69806a886743ec69f7d6edb9123b33d4ad14ce3367be2537985af3585f56886c468fe3aa3af70982c590024d8";
                        };

                        Natures-Compass = fetchurl {
                          url = "https://cdn.modrinth.com/data/fPetb5Kh/versions/nFniEtJV/NaturesCompass-1.21.1-3.4.0-neoforge.jar";
                          sha512 = "5314b536bcb9a594a9cf2bbd46c82468d17e1559bd6c00da9d91e96c0814f50416799a011705f0d184bd731dac3f03dec009c76fea3d02b3556a6013f9649014";
                        };

                        Trample-No-More = fetchurl {
                          url = "https://cdn.modrinth.com/data/Bc9bwujS/versions/W15ZbWlR/tramplenomore-neoforge-1.21.1-21.1.2.jar";
                          sha512 = "73852b6c788cb1aba99f18dc62c8b4ff0da784a2cf3f9c090eb91d071b838dc757fff83bb85f376b31cde5f5a1a33ec9cf8e5bdf86796cbc72c3958057a4a77e";
                        };

                        More-MobGriefing-Options = fetchurl {
                          url = "https://cdn.modrinth.com/data/423SG4Jc/versions/9zpMmDoj/MoreMobGriefingOptions-1.21.1-3.0.1.jar";
                          sha512 = "88af99cf53fc20426da17104b6a452435e8bb05feb7edb3f17657bf30021bd35b75188ac7250e4d51212bee6f26f0ccf67edd96f7d5053f1d941511682c98e43";
                        };

                        Horseman = fetchurl {
                          url = "https://cdn.modrinth.com/data/qIv5FhAA/versions/KKgtKkVW/horseman-neoforge-1.21.1-1.5.9.jar";
                          sha512 = "2521c31411c3569f53adef2594f3a572bac48a8e0d7895dd67ff6662116dd26815ff3ca4a1ecded6fb7c4aaf0b9b95fc2c48311d937b5a5fdcf8b19e82973ad1";
                        };

                        Fusion-Connected-Textures = fetchurl {
                          url = "https://cdn.modrinth.com/data/p19vrgc2/versions/h2GrA0Ku/fusion-1.2.12-neoforge-mc1.21.1.jar";
                          sha512 = "50604fa4125e846b659479a8bb8bcef5db47460a8185902b8655d8b12c6cc67eb3cc4c08fee45e82a6b215976bea2a480e32ce420f062cea88abe17cb362365c";
                        };

                        ##### Dependencies:

                        Architectury-API = fetchurl {
                          url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/ZxYGwlk0/architectury-13.0.8-neoforge.jar";
                          sha512 = "65e3664953385d880320dd6bb818bcb96d361c07c53e2a7f65e64c6a47720ee26b233224ae9cad465ef0b2bbaefdaf30fb0175a983cecd91de058817d6fcf57e";
                        };

                        Curios-API = fetchurl {
                          url = "https://cdn.modrinth.com/data/vvuO3ImH/versions/yohfFbgD/curios-neoforge-9.5.1%2B1.21.1.jar";
                          sha512 = "5981a267686b744e7e3c227f78cbcd5267c14ac6979a28e814695f4589273998563147207fef4a5cdb7cdbdc39797cd95d9e4abadb55869f18e02a38d0654ae5";
                        };

                        GlitchCore = fetchurl {
                          url = "https://cdn.modrinth.com/data/s3dmwKy5/versions/S2TfWrZR/GlitchCore-neoforge-1.21.1-2.1.0.2.jar";
                          sha512 = "7a009ed163d03536fdfaee7b37cb1ec3073204dffcb06a683369aa88da8dbc3780b0ac69d466bb32a3ad9394c97b698d0fda676e1b4dd4edfc50ac5aa2283c32";
                        };

                        TerraBlender = fetchurl {
                          url = "https://cdn.modrinth.com/data/kkmrDlKT/versions/6e8GCrLb/TerraBlender-neoforge-1.21.1-4.1.0.8.jar";
                          sha512 = "9d4b2a1be5139c0fb2fad92ed21805b17d9e83b6ea48e637e018bb14063c1823a206390755dbfe8d025c20fd62ac11cdd84db53ddb956dabaeda01bff57bac50";
                        };

                        Puzzles-Lib = fetchurl {
                          url = "https://cdn.modrinth.com/data/QAGBst4M/versions/7IlRqegD/PuzzlesLib-v21.1.46-1.21.1-NeoForge.jar";
                          sha512 = "f0cf4cd93caaec753d258f84522daaf34bf3b6af96c30f797dc0ddd1019a7e5593f933bcdea474fca18fa065e25293c883548b475d151359d3a260d2b4ec7862";
                        };

                        Citadel = fetchurl {
                          url = "https://cdn.modrinth.com/data/jJfV67b1/versions/uzrkhBpn/citadel-2.7.0-1.21.1.jar";
                          sha512 = "d77d8d25279d877ef94f1e48e770547ba2fbee2f01ed151aa932c6e36ed5dd7f846db096f7b1f9c13f49a3e2fd5de434d20a0924a3232e06d20c7ca5f46e47f6";
                        };

                        Deimos = fetchurl {
                          url = "https://cdn.modrinth.com/data/WQaxNzFg/versions/SW2WCTYz/deimos-1.21.1-neoforge-2.6.jar";
                          sha512 = "e1cd7a42081cddda9d26c744f30d3bc3fa26ba86228c6d1292f67af5814d8b503486a2345422755a6fc6f658a12e47109c767de773130fe26503805e4a3d94ba";
                        };

                        BaguetteLib = fetchurl {
                          url = "https://cdn.modrinth.com/data/OfKzpbRU/versions/guIAbyuH/baguettelib-1.21.1-NeoForge-2.0.3.jar";
                          sha512 = "3def04f7f11ba743516594b69250ca7c54c11e0c4ffeeb718bfd9736096bfb25768642eb210f6cf716f33b8c12faf2e998df2db98cf495f0527620e8bec80a79";
                        };

                        Ritchies-Projectile-Library = fetchurl {
                          url = "https://cdn.modrinth.com/data/B3pb093D/versions/hZ6B2Z0x/ritchiesprojectilelib-2.1.2%2Bmc.1.21.1-neoforge.jar";
                          sha512 = "6d64c84505a5a8fbb96d106603065465c5a2314ec09636900c5c1a31014c12fa68f1a41e758313cbf0d6f95d9a1f53bd67339020f7d8db0e184c23f66aee0330";
                        };

                        SuperMartijns-Core-Lib = fetchurl {
                          url = "https://cdn.modrinth.com/data/rOUBggPv/versions/hcYSe7v7/supermartijn642corelib-1.1.21-neoforge-mc1.21.jar";
                          sha512 = "91e67be718dc288c95e22ba78e54deb75c4f110afddddfbef58480019008d39aaeeb7104fcddfd45a49c5e6ee703b20c1d22c5ad32f63059deef080c7bae4f62";
                        };

                        SuperMartijns-Config-Lib = fetchurl {
                          url = "https://cdn.modrinth.com/data/LN9BxssP/versions/qKL9jM75/supermartijn642configlib-1.1.8-neoforge-mc1.21.jar";
                          sha512 = "768d8ca178c5e653986f5131b7aeb7fa57ce7d32c16ed399ced01b273565a2b640130c55c7092747efeff40dbb0348876b18b415f59b0d16dd2c7f32f1798ce2";
                        };

                        Moonlight-Lib = fetchurl {
                          url = "https://cdn.modrinth.com/data/twkfQtEc/versions/er7S98Q1/moonlight-neoforge-1.21.1-3.0.14.jar";
                          sha512 = "e28aa1a0da057a5099232519165af5fe9a36fdd0e133b18af493d2108a17d071add4e0c85dd02e20100f0e2e3ae09e2416c72d9f77e306e4e711b03e4424e5a5";
                        };

                        Bookshelf = fetchurl {
                          url = "https://cdn.modrinth.com/data/uy4Cnpcm/versions/1sdJl7J1/bookshelf-neoforge-1.21.1-21.1.81.jar";
                          sha512 = "78d4577a8e8fbb241216968475dd73f5b9e5efeb7da802b18a4e6c290e49af6cb4a5676e9855d0d8ff3613f967812e4bd363bbb9196c17c954d19454f84b2214";
                        };

                        Carbon-Config = fetchurl {
                          url = "https://cdn.modrinth.com/data/1jDdpgcc/versions/Mce3ulUV/CarbonConfig-Neoforge-1.21.1-2.0.2.1.jar";
                          sha512 = "06d4e5de53dfef36363e4e8cf7d3c5381894d26731757e42861a16c59885288fe543e9350fbe571cc689aa10799e6ad0675b2316bd090349a16546e2b86b5638";
                        };

                        Create-Deployer-API = fetchurl {
                          url = "https://cdn.modrinth.com/data/OZhUIuou/versions/XrLW2FiE/deployer-0.1.2.jar";
                          sha512 = "1d2ad848e5342758ac6199396c53c2d43419d57337259dfea25a1477b9e7ad76578d02ec8c8eb26acbb21df5b3275d8c5fad89aad2b5a148ece4e23c65c3a517";
                        };

                        Sophisticated-Core = fetchurl {
                          url = "https://cdn.modrinth.com/data/nmoqTijg/versions/8v2bUkbq/sophisticatedcore-1.21.1-1.4.41.1871.jar";
                          sha512 = "c19a98d19c9f5c19f04e96f8d4c6734d76c34138a39ecd3808211a4840e470bcd5ffd3d6ccac6648981adf11f2ec0cbddfb8c8ac182a6105672a98dfe62d6941";
                        };

                        Create-Dragons-Plus = fetchurl {
                          url = "https://cdn.modrinth.com/data/dzb1a5WV/versions/r0TIh2nX/CreateDragonsPlus-1.10.1.jar";
                          sha512 = "cb8ff236250d346f7c76d534a5cd12f75b081d05b542c54cac49cc430a4539061f05562f10b8ba8503423fb6044666418a355aeae31a4e34615d0da41fa14967";
                        };

                        Prickle = fetchurl {
                          url = "https://cdn.modrinth.com/data/aaRl8GiW/versions/EE1FHDyD/prickle-neoforge-1.21.1-21.1.11.jar";
                          sha512 = "154d42795ccf1f3e07714775cdb82fd5db17574319286ced13d86b0456b64e4cf5bb89ffbcbfcefce67b73ed0b83e4e2944e493d79d9a385ff9de23006ee7bf5";
                        };
                      }
                    );
                };

                files = {
                  "config/proxy-compatible-forge.toml".value = {
                    forwarding.secret = secrets.forwarding-secret;
                  };

                  "config/voicechat/voicechat-server.properties".value = {
                    port = 24454;
                  };
                };

                inherit (secrets.create) whitelist operators;

                serverProperties = {
                  # https://minecraft.wiki/w/Server.properties
                  gamemode = "survival";
                  difficulty = "hard";
                  motd = "Create server";
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
            };
          })
          (lib.mkIf (cfg.preset == "oci") {
            services.minecraft-servers.servers = {
              proxy.files."velocity.toml".value = {
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

            settings.persist.root.directories = [ "/srv/minecraft" ];

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
                    };

                    "plugins/voicechat.jar" = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/jMopHMDQ/voicechat-velocity-2.6.4.jar";
                      sha512 = "03db44bdcf8012fdd7c93ce94c3fe37506d6cd39084ac9fcc294a9069d8bc5f9f160423b67af6a43b2fe044e4df9e716fd8b27fe61f404f94bda71556cc21ebc";
                    };
                  };
                };

              };
            };
          }
        ]
      );
    };
}
