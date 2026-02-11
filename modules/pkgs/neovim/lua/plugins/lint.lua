return {
	"nvim-lint",
	after = function()
		require("lint").linters_by_ft = {
			nix = { "statix" },
			python = { "ruff" },
			tex = { "chktex" },
		}
	end,
}
