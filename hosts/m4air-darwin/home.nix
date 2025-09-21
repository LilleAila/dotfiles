{
  pkgs,
  config,
  lib,
  inputs,
  outputs,
  user,
  keys,
  ...
}:
{
  imports = [ ../../home ];

  home = {
    homeDirectory = lib.mkForce "/Users/${user}";
    shellAliases = {
      osbuild = lib.mkForce "sudo darwin-rebuild switch --flake ${config.home.homeDirectory}/dotfiles";
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  settings = {
    browser.firefox.enable = false;
    syncthing.enable = true;
    discord.vesktop = {
      enable = true;
      package = null;
    };

    terminal = {
      zsh.enable = true;
      utils.enable = true;
      neovim.enable = true;
      emulator.enable = true;
    };

    sops.enable = true;
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

  sops.secrets."ssh/m4air-darwin".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".text = keys.ssh.m4air-darwin.public;
  sops.secrets."syncthing/m4air-darwin/cert".path =
    "${config.home.homeDirectory}/Library/Application Support/Syncthing/cert.pem";
  sops.secrets."syncthing/m4air-darwin/key".path =
    "${config.home.homeDirectory}/Library/Application Support/Syncthing/key.pem";
  sops.secrets."syncthing/m4air-darwin/https-cert".path =
    "${config.home.homeDirectory}/Library/Application Support/Syncthing/https-cert.pem";
  sops.secrets."syncthing/m4air-darwin/https-key".path =
    "${config.home.homeDirectory}/Library/Application Support/Syncthing/https-key.pem";

  # TODO: All below should be handled in the modules, through some use of pkgs.stdenv.hostPlatform.isDarwin, or through a specialArg
  # All graphicals applications should be installed through brew.
  programs.firefox.package = lib.mkForce null;
  programs.ghostty.package = lib.mkForce null;

  services.syncthing.settings.folders = {
    "Factorio Saves".path =
      lib.mkForce "${config.home.homeDirectory}/Library/Application Support/factorio";
    "Minecraft".path =
      lib.mkForce "${config.home.homeDirectory}/Library/Application Support/PrismLauncher/instances";
  };

  home.file.".config/sops/age/keys.txt".enable = false;
  home.file."Library/Application Support/sops/age/keys.txt".source = ./../../secrets/sops-key.txt;
  sops.age.keyFile = lib.mkForce "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt";
}
