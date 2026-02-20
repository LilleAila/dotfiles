local opts = { noremap = true, silent = true }

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("n", "H", "_", opts)
vim.keymap.set("n", "L", "g_", opts)

vim.keymap.set("n", "<leader>fd", function()
	local file = vim.fn.expand("%:p")
	local confirm = vim.fn.confirm("Delete file?\n" .. file, "&Yes\n&No", 2)
	if confirm == 1 then
		vim.fn.delete(file)
		vim.cmd("bdelete!")
		print("File deleted: " .. file)
	else
		print("Delete canceled")
	end
end, { noremap = true, silent = true, desc = "Delete file" })

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
