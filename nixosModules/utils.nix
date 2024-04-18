{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.utils.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable various general utilities";
  };

  config = lib.mkIf (config.settings.utils.enable) {
    # TODO: separate into misc. gui and misc. all
    environment.shells = [pkgs.zsh pkgs.fish];
    programs.zsh.enable = true;
    programs.fish.enable = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.fstrim.enable = true;
    services.upower.enable = true;

    programs.nh = {
      package = inputs.nh.packages.${pkgs.system}.nh;
      enable = true;
      flake = "/home/olai/dotfiles";
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

    security.polkit.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # system.nixos.codeName = "hmm";

    # Enable some packages and random stuff
    environment.systemPackages = with pkgs; [
      vim
      wget
      git
      pciutils

      dotool
      wtype

      polkit_gnome
    ];
  };
}
