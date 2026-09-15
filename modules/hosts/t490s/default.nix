{
  self,
  lib,
  inputs,
  ...
}:
{
  configurations.nixos.t490s-nix.module =
    {
      config,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        inputs.declarative-flatpak.nixosModules.default
        ./_hardware-configuration.nix
      ];

      networking.hostId = "c70b6e36";

      boot.zfs = {
        devNodes = "/dev/disk/by-id";
        forceImportRoot = lib.mkForce true;
      };

      environment.systemPackages = with pkgs; [
        qt6.qtwayland
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
          hostname = "t490s-nix";
          wifi.enable = true;
          bluetooth.enable = true;
        };
        utils.enable = true;
        desktop.enable = true;
        sway.enable = true;
        niri.enable = true;
        ewm.enable = false;

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

        zfs.enable = true;
        zfs.snapshots = true;
        impermanence.enable = true;
      };

      environment.sessionVariables.ANKI_WAYLAND = 1;

      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 2;
      # boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelParams = [ "amd_pstate=active" ];

      services.logind.settings.Login = {
        HandleLidSwitch = "ignore"; # NOTE: idk if "ignore" is the correct option
        HandleLidSwitchDocked = "ignore";
      };

      environment.variables.LIBSEAT_BACKEND = "logind";

      services.thermald.enable = true;

      services.auto-cpufreq = {
        enable = false;
        settings = {
          charger = {
            turbo = "auto";
            # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
            governor = "powersave";
            energy_performance_preference = "balance_performance";
            # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq
            scaling_min_freq = 400000; # (400 mHz in kHz)
            # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
            scaling_max_freq = 4546000; # (4546 mHz in kHz)
          };
          battery = {
            governor = "powersave";
            # For some reason, only the performance epp is available when on charger
            # cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
            energy_performance_preference = "power";
            enable_thresholds = true;
            start_threshold = 75;
            stop_threshold = 80;
            turbo = "never";
            scaling_min_freq = 400000; # (400 mHz in kHz)
            scaling_max_freq = 2000000; # (2000 mHz in kHz)
          };
        };
      };

      services.tlp = {
        enable = true;
        settings = {
          # Values commented out are managed by auto-cpufreq instead
          # TLP is only used for GPU and disabling / enabling devices
          # Using both at the same time is not recommended, but meh what could go wrong?

          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;
          RESTORE_THRESHOLDS_ON_BAT = 1;
        };
      };

      system.stateVersion = "26.05";

      sops.secrets."syncthing/t490s/cert" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/cert.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/t490s/key" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/key.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/t490s/https-cert" = {
        path = "${config.hm.home.homeDirectory}/.config/syncthing/https-cert.pem";
        inherit (config.services.syncthing) group;
        owner = config.services.syncthing.user;
      };
      sops.secrets."syncthing/t490s/https-key" = {
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
              geometry = "1920x1200@60";
              position = "0x0";
            }
          ];

          desktop.full.enable = true;
          school.enable = true;
          music.enable = true;
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

        wayland.windowManager.hyprland.settings.input.kb_options = "ctrl:nocaps,altwin:prtsc_rwin";
        home.shellAliases = {
          bt = "bluetooth";
        };

        sops.secrets."yubikey/u2f_keys".path = "${config.hm.home.homeDirectory}/.config/Yubico/u2f_keys";
        sops.secrets."ssh/t490s".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519"; # TODO
        home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.t490s.public;
        # home.file.".ssh/yubikey.pub".text = keys.ssh.yubikey.public;
      };
    };
}
