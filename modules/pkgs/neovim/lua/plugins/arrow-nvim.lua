return {
	"arrow.nvim",
	event = "BufEnter",
	after = function()
		require("arrow").setup({
			show_icons = true,
			leader_key = "ø",
			buffer_leader_key = "m",
		})
	end,
}
