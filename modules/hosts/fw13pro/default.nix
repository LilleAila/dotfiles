{
  self,
  lib,
  inputs,
  ...
}:
{
  configurations.nixos.e14g5-nix.module =
    {
      config,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        ./_hardware-configuration.nix
      ];

      networking.hostId = "6793c78c";

      environment.systemPackages = with pkgs; [
        qt6.qtwayland
      ];

      settings.persist = {
        home = {
          directories = [ ];
          files = [ ".kattisrc" ];
        };
      };

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
        ewm.enable = true;

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
          "/persist/cache" = mkBtrfs "@cache";
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

      # sops.secrets."syncthing/desktop/cert" = {
      #   path = "${config.hm.home.homeDirectory}/.config/syncthing/cert.pem";
      #   inherit (config.services.syncthing) group;
      #   owner = config.services.syncthing.user;
      # };
      # sops.secrets."syncthing/desktop/key" = {
      #   path = "${config.hm.home.homeDirectory}/.config/syncthing/key.pem";
      #   inherit (config.services.syncthing) group;
      #   owner = config.services.syncthing.user;
      # };
      # systemd.services.syncthing.after = [ "sops-nix.service" ];

      hm = {
        settings = {
          monitors = [
            {
              name = "eDP-1";
              geometry = "1920x1200@60";
              position = "0x0";
            }
          ];

          desktop.full.enable = true;
          school.enable = true;
        };

        programs.niri.settings.outputs = {
          "eDP-1" = {
            mode = {
              width = 1920;
              height = 1200;
              refresh = 60.0;
            };
            scale = 1;
            background-color = "#${self.colorScheme.palette.base00}";
          };
        };

        home.packages = with pkgs; [
          neural-amp-modeler-lv2
          ardour
          vscode-fhs
          nautilus
        ];

        wayland.windowManager.hyprland.settings.input.kb_options = "ctrl:nocaps";
        home.shellAliases = {
          bt = "bluetooth";
        };

        # sops.secrets."yubikey/u2f_keys".path = "${config.hm.home.homeDirectory}/.config/Yubico/u2f_keys";
        # sops.secrets."ssh/e14g5".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
        # home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.e14g5.public;
        # home.file.".ssh/yubikey.pub".text = keys.ssh.yubikey.public;
      };
    };
}
