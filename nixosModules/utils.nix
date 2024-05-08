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
    environment.shells = [pkgs.zsh pkgs.fish];
    programs.zsh.enable = true;
    programs.fish.enable = true;

    services.fstrim.enable = true;
    services.upower.enable = true;

    programs.nh = {
      package = inputs.nh.packages.${pkgs.system}.nh;
      enable = true;
      flake = "/home/olai/dotfiles";
      clean.enable = true;
      clean.extraArgs = "--nogcroots --keep-since 4d --keep 3";
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

    console.colors = let
      c = config.hm.colorScheme.palette;
    in [
      "${c.base00}" # black
      "${c.base08}" # red
      "${c.base0B}" # green
      "${c.base0A}" # yellow
      "${c.base0D}" # blue
      "${c.base0E}" # magenta
      "${c.base0C}" # cyan
      "${c.base05}" # gray
      "${c.base03}" # darkgray
      "${c.base08}" # lightred
      "${c.base0B}" # lightgreen
      "${c.base0A}" # lightyellow
      "${c.base0D}" # lightblue
      "${c.base0E}" # lightmagenta
      "${c.base0C}" # lightcyan
      "${c.base06}" # white
    ];
  };
}
