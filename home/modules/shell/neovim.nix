{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.terminal.neovim.enable = lib.mkEnableOption "neovim";

  config =
    lib.mkIf (config.settings.terminal.neovim.enable)
    (lib.mkMerge [
      {
        # Putting this as programs.neovim.package does not work, so configuring manually:
        # Here is my nixvim config: https://github.com/LilleAila/nvim-nix/
        home.packages = [
          (inputs.nixvim-config.packages."${pkgs.system}".nvim.override {
            colorScheme = config.colorScheme;
          })
          # pkgs.nvimpager
        ];

        home.sessionVariables = {
          EDITOR = "nvim";
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
      (lib.mkIf (config.settings.terminal.emulator.enable) {
        xdg.desktopEntries.nvim = {
          name = "Neovim";
          genericName = "Text Editor";
          icon = "nvim";
          exec = "${config.settings.terminal.emulator.exec} ${lib.getExe config.programs.neovim.package} %f";
        };
        xdg.mimeApps.defaultApplications = {
          "text/plain" = "nvim.desktop";
          "application/x-shellscript" = "nvim.desktop";
        };
      })
    ]);
}
