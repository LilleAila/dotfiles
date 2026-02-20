local opts = function(desc)
	return { noremap = true, silent = true, desc = desc }
end

return {
	"vim-dadbod",

	after = function()
		vim.keymap.set("n", "<leader>du", ":DBUI<cr>", opts("DBUI"))
	end,
}
