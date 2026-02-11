local ls = require("luasnip")

local M = {}

function M.load_snippets()
  snippet_path = debug.getinfo(1).source:sub(2):gsub("init.lua", "snippets")
  require("luasnip.loaders.from_lua").lazy_load({ paths = snippet_path })

  ls.filetype_extend("markdown", {"tex_math"})
  ls.filetype_extend("tex", {"tex_math"})
end

return M
