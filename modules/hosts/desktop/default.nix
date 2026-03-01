{
  self,
  lib,
  inputs,
  ...
}:
{
  configurations.nixos.nixdesktop.module =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        ./_hardware-configuration.nix
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostId = "7dbd1705";

      fileSystems = {
        "/srv/jellyfin" = {
          device = "zroot/jellyfin";
          fsType = "zfs";
        };
      };

      settings = {
        locale = {
          main = "en_US.UTF-8";
          other = "nb_NO.UTF-8";
          timeZone = "Europe/Oslo";
        };
        networking = {
          enable = true;
          hostname = "nixdesktop";
          wifi.enable = true;
          bluetooth.enable = true;
        };
        utils.enable = true;
        console = {
          font = "ter-u16n";
          keyMap = "no";
        };
        sops.enable = true;

        ssh.enable = true;
        ssh.keys = with self.keys.ssh; [
          e14g5.public
          t420.public
          x220.public
          pixel8a.public
          installer.public
        ];

        zfs.enable = true;
        zfs.encryption = false;
        zfs.snapshots = true;
        impermanence.enable = true;

        greeter.enable = true;
        xserver.xwayland.enable = true;
        desktop.enable = true;
        sway.enable = true;
        niri.enable = true;
        syncthing.enable = true;
        sound.enable = true;
        gpg.enable = true;
        yubikey.enable = true;
        virtualisation.enable = true;

        jellyfin.enable = true;
        samba.enable = true;

        nvidia.enable = true;
      };

      specialisation = {
        # nvidia enabled is default
        virtualisation.configuration = {
          settings = {
            nvidia.enable = lib.mkForce false;
            nvidia.passthrough = {
              enable = true;
              ids = [
                "10de:2216"
                "10de:1aef"
              ];
            };

          };

          environment.sessionVariables.NIXOS_ACTIVE_SPECIALISATION = "virtualisation";
        };
      };

      # random packages trying to get vaapi to work properly with webm
      hardware.graphics.extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
        intel-media-driver
        intel-vaapi-driver
      ];

      services.xserver.videoDrivers = [ "amdgpu" ];
      boot.initrd.kernelModules = [ "amdgpu" ];

      system.stateVersion = "24.11";

      sops.secrets."syncthing/desktop/cert" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/cert.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/desktop/key" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/key.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      systemd.services.syncthing.after = [ "sops-nix.service" ];

      hm = {
        settings = {
          monitors = [
            {
              name = "HDMI-A-1";
              geometry = "1920x1080@75";
              position = "0x0";
            }
          ];
          gaming.enable = true;
          gaming.steam.enable = true;
          desktop.enable = true;
          desktop.full.enable = true;
          dvd.enable = true;

          virtualisation.enable = true;

          school.enable = true;

          persist.home.cache = [
            "hd-bet-weights"
            "hd-bet_params"
          ];
        };

        home.packages = with pkgs; [
          blender
        ];

        programs.niri.settings.outputs = {
          "DP-2" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 75.0;
            };
            scale = 1;
            background-color = "#${self.colorScheme.palette.base00}";
          };
        };

        sops.secrets."ssh/desktop".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
        home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.desktop.public;

        sops.secrets."yubikey/u2f_keys".path = "${config.hm.home.homeDirectory}/.config/Yubico/u2f_keys";
      };
    };
}
