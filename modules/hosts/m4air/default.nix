{ self, lib, ... }:
{
  configurations.darwin."Olais-MacBook-Air".module =
    {
      user,
      pkgs,
      config,
      ...
    }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";

      settings = {
        aerospace.enable = true;
        brew.enable = true;
        jankyborders.enable = true;
        misc.enable = true;
        nix.enable = true;
        system.enable = true;

        sops.enable = true;
      };

      environment.systemPackages = [
        config.hm.settings.plover.package
      ];
      hm.programs.plover.package = lib.mkForce pkgs.emptyDirectory;
      # launchd.user.agents.plover = {
      #   command = "${config.hm.settings.plover.package}/Applications/Plover.app/Contents/MacOS/Plover";
      #   serviceConfig = {
      #     KeepAlive = true;
      #     RunAtLoad = true;
      #   };
      #   managedBy = "settings.plover.enable";
      # };

      # NOTE: might want to do this in hm instead.
      system.activationScripts.extraActivation.text =
        let
          wallpaper = self.packages.${pkgs.stdenv.hostPlatform.system}.wallpaper.override {
            inherit (self) colorScheme;
            logo = "apple";
          };
        in
        ''
          /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"${wallpaper}\""
        '';

      hm = {
        home.shellAliases = {
          osbuild = lib.mkForce "sudo darwin-rebuild switch --flake ${config.hm.home.homeDirectory}/dotfiles";
        };

        settings = {
          browser.firefox.enable = true; # TODO: optimize for macos
          syncthing.enable = true;
          discord.vesktop = {
            enable = true;
            package = null;
          };
          plover.enable = true;

          terminal = {
            zsh.enable = true;
            utils.enable = true;
            neovim.enable = true;
            emulator.enable = true;
          };
        };

        programs.lf.enable = lib.mkForce false;

        home.packages = with pkgs; [
          ffmpeg
          fd
          ripgrep
          pngpaste
          libqalculate
        ];

        # Brew was installed imperatively :(
        # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        programs.zsh.profileExtra = # sh
          ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
          '';

        sops.secrets."ssh/m4air-darwin".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
        home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.m4air-darwin.public;
        sops.secrets."syncthing/m4air-darwin/cert".path =
          "${config.hm.home.homeDirectory}/Library/Application Support/Syncthing/cert.pem";
        sops.secrets."syncthing/m4air-darwin/key".path =
          "${config.hm.home.homeDirectory}/Library/Application Support/Syncthing/key.pem";
        sops.secrets."syncthing/m4air-darwin/https-cert".path =
          "${config.hm.home.homeDirectory}/Library/Application Support/Syncthing/https-cert.pem";
        sops.secrets."syncthing/m4air-darwin/https-key".path =
          "${config.hm.home.homeDirectory}/Library/Application Support/Syncthing/https-key.pem";

        # TODO: All below should be handled in the modules, through some use of pkgs.stdenv.hostPlatform.isDarwin, or through a specialArg
        # All graphicals applications should be installed through brew.
        programs.firefox.package = lib.mkForce null;
        programs.ghostty.package = lib.mkForce null;

        services.syncthing.settings.folders = {
          "Factorio Saves".path =
            lib.mkForce "${config.hm.home.homeDirectory}/Library/Application Support/factorio";
          "Minecraft".path =
            lib.mkForce "${config.hm.home.homeDirectory}/Library/Application Support/PrismLauncher/instances";
        };

        sops.age.keyFile = lib.mkForce "${config.hm.home.homeDirectory}/Library/Application Support/sops/age/keys.txt";
      };
    };
}
