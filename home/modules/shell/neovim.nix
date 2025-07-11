{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.terminal.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.settings.terminal.neovim.enable (
    lib.mkMerge [
      {
        # Putting this as programs.neovim.package does not work, so configuring manually:
        # Here is my nixvim config: https://github.com/LilleAila/nvim-nix/
        home.packages = [
          # (inputs.nixvim-config.packages."${pkgs.system}".nvim.override { inherit (config) colorScheme; })
          inputs.nvf-config.packages.${pkgs.system}.default
          # pkgs.nvimpager
        ];

        home.sessionVariables = {
          EDITOR = "nvim";
          OBSIDIAN_REST_API_KEY = (import ../../../secrets/tokens.nix).obsidian;
          # PAGER = "nvimpager";
        };

        home.shellAliases = {
          v = "nvim";
          vi = "nvim";
          vim = "nvim";
          nano = "nvim";
          e = "nvim";
          vnim = "nvim";
          nvi = "nvim";
          nivm = "nvim";
          nimv = "nvim";
          nv = "nvim";
          nvimnvim = "nvim";

          vimdiff = "nvim -d";
          diff = "nvim -d";
        };

        settings.persist.home.directories = [
          ".local/share/nvim"
          ".local/state/nvim"
        ];
      }
      (lib.mkIf config.settings.terminal.emulator.enable {
        xdg.desktopEntries.nvim = {
          name = "Neovim";
          genericName = "Text Editor";
          icon = "nvim";
          exec = "${config.settings.terminal.emulator.exec} nvim %f";
        };
      })
    ]
  );
}
