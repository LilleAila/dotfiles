{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.terminal.utils.enable) (lib.mkMerge [
    {
      programs.zellij = {
        enable = true;
        settings = {};
      };
    }
    (lib.mkIf (config.settings.terminal.emulator.name == "kitty") {
      # programs.zsh.initExtra = ''
      #   ${lib.getExe config.programs.zellij.package}
      # '';
      programs.kitty.settings.shell = ''
        ${lib.getExe config.programs.zellij.package}
      '';
    })
  ]);
}
