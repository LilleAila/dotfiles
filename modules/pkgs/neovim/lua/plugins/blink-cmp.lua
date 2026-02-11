return {
	"blink.cmp",
	after = function()
		require("blink.cmp").setup({
			snippets = { preset = "luasnip" },

			keymap = {
				preset = "none",
				["<C-j>"] = { "select_next" },
				["<C-k>"] = { "select_prev" },
				["<C-y>"] = { "select_and_accept" },
			},

			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
			},
		})
	end,
}
