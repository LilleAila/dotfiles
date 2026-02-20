{
  inputs,
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

            nvim-web-devicons
            mini-icons
            mini-statusline
            mini-notify
            fzf-lua
            blink-cmp
            self.packages.${pkgs.stdenv.hostPlatform.system}.nvim-snippets
            luasnip
            nvim-treesitter.withAllGrammars
            vim-localvimrc

            vim-dadbod
            vim-dadbod-ui
            vim-dadbod-completion

            # NOTE: this is in the wrong place it should probably be done in another way something like this: https://github.com/Goxore/nixconf/blob/a33777adcce4a55ce5d3d74c67695059e19a8f76/modules/wrappedPrograms/neovim/neovim.nix#L55
            pkgs.fzf
          ];

          opt = with pkgs.vimPlugins; [
            which-key-nvim
            mini-files
            nvim-lspconfig
            obsidian-nvim
            mini-hipatterns
            nvim-lint
            conform-nvim
            mini-pairs
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
