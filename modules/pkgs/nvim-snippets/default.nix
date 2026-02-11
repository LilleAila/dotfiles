{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.nvim-snippets = pkgs.callPackage (
        { vimUtils, vimPlugins }:
        vimUtils.buildVimPlugin {
          name = "lilleaila-snippets";
          src = ./.;
          dependencies = with vimPlugins; [
            luasnip
            nvim-treesitter
          ];
        }
      ) { };
    };
}
