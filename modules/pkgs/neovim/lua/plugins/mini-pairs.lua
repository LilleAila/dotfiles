return {
	"mini.pairs",
	event = "BufEnter",
	after = function()
		require("mini.pairs").setup()
	end,
}
