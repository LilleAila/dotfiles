return {
	"nvim-treesitter",
	after = function()
		require("nvim-treesitter.config").setup({
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
