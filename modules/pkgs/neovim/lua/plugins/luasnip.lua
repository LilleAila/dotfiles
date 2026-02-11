return {
	"luasnip",
	event = "BufEnter",
	after = function()
		require("luasnip").setup({
			delete_check_events = "TextChanged",
			enable_autosnippets = true,
			history = false,
			store_selection_keys = "<Tab>",
			update_events = "TextChanged,TextChangedI",
		})

		require("lilleaila-snippets").load_snippets()

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			local ls = require("luasnip")
			if ls.expand_or_locally_jumpable() then
				vim.schedule(function()
					ls.expand_or_jump()
				end)
				return "<ignore>"
			else
				return vim.api.nvim_replace_termcodes("<tab>", true, true, true)
			end
		end, { noremap = true, silent = true, expr = true })

		vim.keymap.set({ "i", "s" }, "<S-tab>", function()
			local ls = require("luasnip")
			if ls.jumpable(-1) then
				vim.schedule(function()
					ls.jump(-1)
				end)
			end
		end, { noremap = true, silent = true })
	end,
}
