return {
	"mini.hipatterns",
	event = "BufEnter",
	after = function()
		local hi = function(pattern, group)
			return { group = group, pattern = "%f[%w]()" .. pattern .. "()%f[%W]" }
		end

		require("mini.hipatterns").setup({
			highlighters = {
				todo = hi("TODO", "Todo"),
				base16_color = {
					pattern = "base0[%dA-F]",
					group = function(_, match)
						local words = require("colorscheme")
						local hex = words[match]
						if hex == nil then
							return nil
						end
						return MiniHipatterns.compute_hex_color_group(hex, bg)
					end,
				},
			},
		})
	end,
}
