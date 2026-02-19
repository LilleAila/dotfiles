local o = vim.opt

local function mk_spell(langs)
	return function()
		local home = os.getenv("HOME")
		o.spell = true
		o.spelllang = langs

		local spellfiles = {}
		for _, lang in ipairs(langs) do
			local base_lang = vim.split(lang, "_")[1]
			table.insert(spellfiles, home .. "/.spell/spell/" .. base_lang .. ".utf-8.add")
		end

		o.spellfile = spellfiles
	end
end

local opts = function(desc)
	return { noremap = true, silent = true, desc = desc }
end

vim.keymap.set("n", "<leader>cle", mk_spell({ "en_us", "nb", "fr", "nn" }), opts("Engelsk"))
vim.keymap.set("n", "<leader>clf", mk_spell({ "fr", "en_us", "nb", "nn" }), opts("Fransk"))
vim.keymap.set("n", "<leader>clb", mk_spell({ "nb", "en_us", "fr" }), opts("Norsk Bokmål"))
vim.keymap.set("n", "<leader>cln", mk_spell({ "nn", "en_us", "fr" }), opts("Norsk Nynorsk"))

vim.keymap.set("n", "<leader>cd", ":setlocal nospell<cr>", opts("Disable spellcheck"))
vim.keymap.set("n", "<leader>cc", ":FzfLua spell_suggest<cr>", opts("See suggestions"))
