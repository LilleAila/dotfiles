# Vimjoyer: https://www.youtube.com/watch?v=-G8mN6HJSZE
# `nix build .#nixosConfigurations.installer.config.system.build.isoImage`
# `nix run nixpkgs#nixos-generators -- --format iso --flake .#installer -o result`
{ self, lib, ... }:
{
  configurations.nixos.installer = {
    user = "nixos";
    module =
      {
        config,
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];

        settings = {
          user.enable = false;

          console = {
            font = "ter-u16n";
            keyMap = "no";
          };

          locale = {
            main = "en_US.UTF-8";
            other = "nb_NO.UTF-8";
            timeZone = "Europe/Oslo";
          };

          ssh.enable = true;
          ssh.keys = with self.keys.ssh; [
            e14g5.public
            t420.public
          ];
        };
        programs.zsh.enable = true;
        users.users.nixos.shell = pkgs.zsh;

        # TODO: make a module (separate from yubikey)
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
          pinentryPackage = pkgs.pinentry-tty;
        };

        networking.hostName = "nixos-installer";

        system.stateVersion = "24.05";
        nixpkgs.hostPlatform = "x86_64-linux";

        hm = {
          settings = {
            terminal = {
              zsh = {
                enable = true;
                theme = "nanotech";
              };
              utils.enable = true;
              neovim.enable = true;
            };
          };
          home.username = lib.mkForce "nixos";
          sops.secrets."ssh/installer".path = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
          home.file.".ssh/id_ed25519.pub".text = self.keys.ssh.installer.public;
          home.file.".config/sops/age/keys.txt".source = ../../secrets/sops-key.txt;
          home.file."gpg-key.asc".source = ../../secrets/gpg-key.asc; # couldn't find a way to declaratively import
          home.packages = with pkgs; [
            jq
            fzf
            git
          ];

          home.file."install.sh" = {
            source = ./install.sh;
            executable = true;
          };

          home.file."post-install.sh" = {
            source = ./post-install.sh;
            executable = true;
          };
        };
      };
  };
}
