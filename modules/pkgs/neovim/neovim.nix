{
  inputs,
  lib,
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = inputs.mnw.lib.wrap pkgs {
        neovim = pkgs.neovim-unwrapped;

        initLua = # lua
          ''
            require("init")
            require("lz.n").load("plugins")
          '';

        plugins = {
          start = with pkgs.vimPlugins; [
            lz-n
            mini-icons
            (pkgs.writeTextFile {
              name = "colorscheme-${self.colorScheme.slug}";
              destination = "/lua/colorscheme/init.lua";
              text =
                with self.colorScheme.palette; # lua
                ''
                  local M = {
                    base00 = "#${base00}",
                    base01 = "#${base01}",
                    base02 = "#${base02}",
                    base03 = "#${base03}",
                    base04 = "#${base04}",
                    base05 = "#${base05}",
                    base06 = "#${base06}",
                    base07 = "#${base07}",
                    base08 = "#${base08}",
                    base09 = "#${base09}",
                    base0A = "#${base0A}",
                    base0B = "#${base0B}",
                    base0C = "#${base0C}",
                    base0D = "#${base0D}",
                    base0E = "#${base0E}",
                    base0F = "#${base0F}",
                  }

                  return M
                '';
            })
          ];

          opt = with pkgs.vimPlugins; [
            fzf-lua
            which-key-nvim
            nvim-treesitter.withAllGrammars
            mini-files
            nvim-web-devicons

            pkgs.fzf
          ];

          dev.myconfig = {
            pure = ./.;
            impure = # lua
              ''
                vim.uv.os_homedir() .. '/modules/pkgs/neovim'
              '';
          };
        };
      };
    };
}
