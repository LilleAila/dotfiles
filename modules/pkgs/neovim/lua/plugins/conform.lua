return {
	"conform.nvim",
	after = function()
		require("conform").setup({
			format_after_save = {
				lsp_format = "never",
				async = true,
			},

			formatters_by_ft = {
				haskell = { "ormolu" },
				html = { "prettier", "prettierd", stop_after_first = true },
				css = { "prettier", "prettierd", stop_after_first = true },
				javascript = { "prettier", "prettierd", stop_after_first = true },
				javascriptreact = { "prettier", "prettierd", stop_after_first = true },
				typescript = { "prettier", "prettierd", stop_after_first = true },
				markdown = { "prettier", "prettierd", stop_after_first = true },
				python = { "ruff" },
				lua = { "stylua" },
				nix = { "nixfmt" },
				rust = { "rustfmt" },
				typst = { "typstyle" },
			},
		})
	end,
}
