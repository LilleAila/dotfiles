local ls = require("lilleaila-snippets.helpers.ls")
local d, fmta = ls.d, ls.fmta

local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip

local M = {
  tasnip({ trig = "mm", name = "inline math" }, [[$$1$]]),
  tasnip({ trig = "md", name = "display math" }, [[
    $$
    $1
    $$
  ]]),
  _masnip({ trig = "aa", name = "answer" }, fmta([[\underline{\underline{<>}}]], { d(1, utils.get_visual) })),
  masnip({ trig = "ma", name = "aligned math" }, [[
    \begin{align}
      $1&$2 & $3
    \end{align}
  ]])
}

return M
