return {
	"typst-preview.nvim",
	after = function()
		require("typst-preview").setup({
			follow_cursor = true,
		})
	end,

	keys = {
		{ "<leader>lt", ":TypstPreview<cr>", desc = "Preview typst" },
	},
}
