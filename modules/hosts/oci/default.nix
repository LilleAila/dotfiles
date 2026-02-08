{ self, lib, ... }:
{
  configurations.nixos.oci-nix.module =
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

      settings = {
        locale = {
          main = "en_US.UTF-8";
          other = "nb_NO.UTF-8";
          timeZone = "Europe/Oslo";
        };
        networking = {
          enable = true;
          hostname = "oci-nix";
        };
        utils.enable = true;
        console = {
          font = "ter-u32n";
          keyMap = "no";
        };
        sops.enable = true;
        ssh.enable = true;
        ssh.keys = with self.keys.ssh; [
          e14g5.public
          t420.public
          desktop.public
          m4air-darwin.public
          pixel8a.public
        ];

        caddy.enable = true;
        syncthing.enable = true;
        webdav.enable = true;
        calibre-web.enable = true;
        minecraft.enable = true;
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-tty;
      };

      services.pocketbase = {
        enable = true;
      };

      services.caddy.virtualHosts."pb-typing.olai.dev".extraConfig = ''
        reverse_proxy 127.0.0.1:8090 {
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}
            header_up Host {host}
        }
      '';

      services.tinyproxy = {
        enable = true;
        settings = {
          Port = 8888;
          Allow = "0.0.0.0/0";
        };
      };

      services.caddy.virtualHosts."proxy.olai.dev".extraConfig = ''
        basic_auth {
          proxyuser $2a$14$bD5hJ34MsRTbFaUZkTLSRuGWgvhkSNZzP6pz2sCgzjTPzjDMnEHia
        }

        reverse_proxy localhost:8888 {
          transport http {
            keepalive 10s
          }
        }
      '';

      environment.systemPackages = with pkgs; [
        # Terminfo for ssh
        kitty
        ghostty
      ];

      system.stateVersion = "24.05";

      hm = {
        settings = {
          # emacs.enable = true;
          terminal = {
            zsh = {
              enable = true;
              theme = "nanotech";
            };
            utils.enable = true;
            neovim.enable = true;
          };
          # other.enable = true;
        };

        sops.secrets."ssh/oci".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
        home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.oci.public;
      };
    };
}
