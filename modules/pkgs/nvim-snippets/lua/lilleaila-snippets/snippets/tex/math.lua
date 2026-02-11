local ls = require("lilleaila-snippets.helpers.ls")
local d, fmta = ls.d, ls.fmta
local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip

local M = {
  tasnip({ trig = "mm", name = "inline math" }, [[$ $1 $]]),
  tasnip({ trig = "mf", name = "flalign math" }, [[
    \begin{flalign*}
      $1&$2 & $0
    \end{flalign*}
  ]]),
  tasnip({ trig = "ma", name = "align math" }, [[
    \begin{align*}
      $1&$2 & $0
    \end{align*}
  ]]),

  _masnip({ trig = "aa", name = "answer" }, fmta([[\ans{<>}]], { d(1, utils.get_visual) })),
  masnip({ trig = "na", name = "newline with answer" }, [[
    \\\\
    \ans{$1&$2} & $0
  ]]),
}

return M
