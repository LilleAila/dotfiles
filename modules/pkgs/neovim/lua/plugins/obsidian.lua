local COLORSCHEME = require("colorscheme")

return {
	"obsidian.nvim",
	cmd = "Obsidian",
	after = function()
		require("obsidian").setup({
			legacy_commands = false,

			workspaces = {
				{
					name = "personal",
					path = "~/notes/obsidian",
				},
			},

			notes_subdir = "Notes",
			daily_notes = {
				folder = "Daily",
			},

			picker = {
				name = "fzf-lua",
			},

			ui = {
				ignore_conceal_warn = true,
				checkboxes = {
					[" "] = { hl_group = "ObsidianTodo" },
					[">"] = { hl_group = "ObsidianRightArrow" },
					["x"] = { hl_group = "ObsidianDone" },
				},
				hl_groups = {
					ObsidianTodo = { fg = COLORSCHEME.base0A },
					ObsidianDone = { fg = COLORSCHEME.base0B },
					ObsidianRightArrow = { fg = COLORSCHEME.base09 },
					ObsidianBullet = { fg = COLORSCHEME.base0D },
					ObsidianRefText = { fg = COLORSCHEME.base0E },
					ObsidianExtLinkIcon = { fg = COLORSCHEME.base0E },
					ObsidianTag = { fg = COLORSCHEME.base0C },
					ObsidianBlockID = { fg = COLORSCHEME.base0C },
					ObsidianHighlightText = { fg = COLORSCHEME.base01, bg = COLORSCHEME.base0A },
				},
			},

			preferred_link_style = "wiki",

			note_id_func = function(title)
				local name = ""
				if title ~= nil then
					name = title
				else
					-- Ask the user for a name
					name = vim.fn.input("Enter note name: ")
					if name == "" then
						-- If no name is given, generate a random one.
						for _ = 1, 5 do
							name = name .. string.char(math.random(65, 90))
						end
					end
				end
				-- transform the name into a valid file name and append the date in ISO 8601 format
				local suffix = name:gsub(" ", "-"):lower():gsub("[^a-z0-9-æøå]", "")
				return tostring(os.date("%Y%m%dT%H%M")) .. "-" .. suffix
			end,

			frontmatter = {
				func = function(note)
					if note.title then
						note:add_alias(note.title)
					end

					local out = { id = note.id, aliases = note.aliases, tags = note.tags }

					if not note.date then
						local date = tostring(os.date("%Y-%m-%d"))
						out.date = date
					end

					if note.title then
						out.title = note.title
					end

					-- Keep existing items
					if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
						for k, v in pairs(note.metadata) do
							out[k] = v
						end
					end

					return out
				end,
			},

			attachments = {
				folder = { "Assets" },
				img_name_func = function()
					return tostring(os.date("%Y%m%dT%H%M")) .. "-"
				end,
			},
		})
	end,

	keys = {
		{ "<leader>oo", ":Obsidian quick_switch<cr>", desc = "Quick switch" },
		{ "<leader>os", ":Obsidian search<cr>", desc = "Search" },
		{ "<leader>od", ":Obsidian today<cr>", desc = "Daily note" },
		{ "<leader>oa", ":Obsidian open<cr>", desc = "Open app" },
		{ "<leader>op", ":Obsidian paste_img<cr>", desc = "Paste image" },
	},
}
