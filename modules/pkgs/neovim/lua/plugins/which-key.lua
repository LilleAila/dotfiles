return {
	"which-key.nvim",
	after = function()
		local wk = require("which-key")
		wk.setup({
			preset = "helix",
			delay = 0,
			icons = {
				mappings = false,
				separator = "➜",
				group = "",
			},
			triggers = {
				{
					"<leader>",
					mode = "n",
				},
			},
		})

		wk.add({
			{ "<leader>f", desc = "Picker" },
			{ "<leader>l", desc = "LSP" },
			{ "<leader>o", desc = "Obsidian" },
		})
	end,
}
