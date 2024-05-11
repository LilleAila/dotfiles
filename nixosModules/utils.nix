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
      clean.extraArgs = "--nogcroots --keep-since 4d --keep 4";
    };

    programs.nano.enable = false;

    services.envfs.enable = true;

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
