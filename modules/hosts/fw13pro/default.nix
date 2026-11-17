{
  self,
  lib,
  inputs,
  ...
}:
{
  configurations.nixos.fw13pro-nix.module =
    {
      config,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        ./_hardware-configuration.nix
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      ];

      networking.hostId = "6793c78c";

      environment.systemPackages = with pkgs; [
        qt6.qtwayland
      ];

      settings.persist = {
        home = {
          directories = [
            ".config/spotify"
            ".cache/spotify"
          ];
          files = [ ".kattisrc" ];
        };
        root.files = [
          "/etc/machine-id"
        ];
      };

      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];

      settings = {
        greeter.enable = true;
        xserver.xwayland.enable = true;
        locale = {
          main = "en_US.UTF-8";
          other = "nb_NO.UTF-8";
          timeZone = "Europe/Oslo";
        };
        user.shell = pkgs.zsh;
        networking = {
          enable = true;
          hostname = "fw13pro-nix";
          wifi.enable = true;
          bluetooth.enable = true;
        };
        utils.enable = true;
        desktop.enable = true;
        sway.enable = true;
        niri.enable = true;
        llama-cpp.enable = true;
        # ewm.enable = true;

        ssh.enable = true;
        ssh.keys = with self.keys.ssh; [
          desktop.public
          t420.public
          x220.public
          pixel8a.public
        ];

        syncthing.enable = true;
        sound.enable = true;
        console = {
          font = "ter-u16n";
          keyMap = "no";
        };
        sops.enable = true;
        gpg.enable = true;
        yubikey.enable = true;
        virtualisation.enable = true;
        docker.enable = true;

        impermanence.enable = true;
      };

      boot.initrd.luks.devices."cryptroot" = {
        device = "/dev/disk/by-label/NIXCRYPT";
        allowDiscards = true;
      };

      boot.tmp = {
        useTmpfs = true;
        tmpfsSize = "8G";
      };

      fileSystems =
        let
          mkBtrfs = subvol: {
            device = "/dev/mapper/cryptroot";
            fsType = "btrfs";
            options = [
              "subvol=${subvol}"
              "compress=zstd"
              "noatime"
            ];
          };
        in
        {
          "/boot" = {
            device = "/dev/disk/by-label/NIXBOOT";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };

          "/nix" = mkBtrfs "@nix";
          "/persist" = mkBtrfs "@persist" // {
            neededForBoot = true;
          };
          "/persist/cache" = mkBtrfs "@cache" // {
            neededForBoot = true;
          };
        };

      environment.sessionVariables.ANKI_WAYLAND = 1;

      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 2;
      # boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelParams = [ "amd_pstate=active" ];

      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchDocked = "suspend";
      };

      environment.variables.LIBSEAT_BACKEND = "logind";

      system.stateVersion = "26.05";

      sops.secrets."syncthing/fw13pro/cert" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/cert.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/fw13pro/key" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/key.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/fw13pro/https-cert" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/https-cert.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/fw13pro/https-key" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/https-key.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      systemd.services.syncthing.after = [ "sops-nix.service" ];

      hm = {
        settings = {
          monitors = [
            {
              name = "eDP-1";
              geometry = "2880x1920@120";
              position = "0x0";
            }
          ];

          desktop.full.enable = true;
          school.enable = true;
          wm.swaybg.wallpaper = lib.mkForce ./wallpaper.png;
          music.enable = true;

          nix.unfree = [ "spotify" ];
        };

        programs.niri.settings = {
          outputs = {
            "eDP-1" = {
              mode = {
                width = 2280;
                height = 1920;
                refresh = 120.0;
              };
              scale = 1;
              background-color = "#${self.colorScheme.palette.base00}";
            };
          };

          input = {
            touchpad = {
              tap = false;
              dwt = true;
              accel-speed = 0.5;
              scroll-factor = 0.4;
              click-method = "clickfinger";
            };
          };
        };
        home.packages = with pkgs; [
          neural-amp-modeler-lv2
          ardour
          nautilus
          spotify
        ];

        wayland.windowManager.hyprland.settings.input.kb_options = "ctrl:nocaps";
        home.shellAliases = {
          bt = "bluetooth";
        };

        sops.secrets."ssh/fw13pro".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
        home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.fw13pro.public;
      };
    };
}
