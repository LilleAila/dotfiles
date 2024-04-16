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
        settings = {
          themes.nix-colors = let
            c = config.colorScheme.colors;
          in {
            fg = "#${c.base06}";
            bg = "#${c.base00}";
            red = "#${c.base08}";
            green = "#${c.base0B}";
            yellow = "#${c.base0A}";
            blue = "#${c.base0D}";
            magenta = "#${c.base0E}";
            orange = "#${c.base09}";
            cyan = "#${c.base0C}";
            black = "#${c.base00}";
            white = "#${c.base05}";
          };
          theme = "nix-colors";
        };
      };
      home.shellAliases = {
        zj = "zellij";
      };
    }
    # (lib.mkIf (config.settings.terminal.emulator.name == "kitty") {
    #   programs.kitty.settings.shell = ''
    #     ${lib.getExe config.programs.zellij.package}
    #   '';
    # })
  ]);
}
