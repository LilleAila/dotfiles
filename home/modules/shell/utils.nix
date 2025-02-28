{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.terminal.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf config.settings.terminal.utils.enable {
    home.shellAliases =
      {
        bigfiles = "sudo fd --one-file-system --base-directory / --type f --hidden --exec ls -lS | sort -k5,5nr | head -n 10";
        current-generation = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 3";

        cat = "${pkgs.bat}/bin/bat";

        cd = "z";
        open = "xdg-open";
        o = "xdg-open";
        img = "kitty +kitten icat";
        c = ''cd $(find . -type d -not -path "*/.*" -not -path "." | fzf -m)'';

        qkb = "qmk compile -kb beekeeb/piantor_pro -km olai && sudo mount /dev/disk/by-label/RPI-RP2 /mnt/qmk -m && sudo cp $HOME/qmk_firmware/beekeeb_piantor_pro_olai.uf2 /mnt/qmk/";
      }
      // (
        let
          flakePath = "${config.home.homeDirectory}/dotfiles";
          remoteBuild =
            hostname:
            "nixos-rebuild switch --flake ${flakePath}#${hostname} --target-host olai@${hostname}.local --use-remote-sudo";
        in
        {
          osbuild = lib.mkDefault "sudo nixos-rebuild switch --flake ${flakePath} --show-trace --option eval-cache false";
          osbuild-t420 = remoteBuild "t420-nix";
        }
      );

    programs.ssh = {
      enable = true;
      # NOTE: this is a user-specific setting, that should maybe be set somewhere else. desktop/default.nix?
      matchBlocks = {
        oci = {
          hostname = "158.179.205.169";
          user = "olai";
          localForwards = [
            {
              # Forward syncthing interface
              bind.port = 9999;
              host.port = 8384;
              host.address = "127.0.0.1";
            }
          ];
        };
      };
    };
    # services.ssh-agent.enable = true;
    # programs.ssh.addKeysToAgent = "yes";

    programs.starship = {
      enable = true;
      settings = {
        command_timeout = 1000;
        add_newline = false;
        format = "$all";
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultOptions = [ "--color 16" ];
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--color=always"
        "--no-quotes"
        "--hyperlink"
      ];
    };

    programs.ripgrep.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    settings.persist.home.cache = [
      ".local/share/direnv"
      ".local/share/zoxide"
      ".ssh"
      ".cache/nix-index"
    ];

    home.packages = with pkgs; [
      nurl
      sops
      tldr
      file
      wget
      fd
    ];
  };
}
