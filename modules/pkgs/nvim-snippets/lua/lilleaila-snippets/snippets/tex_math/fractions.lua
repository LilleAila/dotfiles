local ls            = require("lilleaila-snippets.helpers.ls")
local i, d, f       = ls.i, ls.d, ls.f
local fmta, postfix = ls.fmta, ls.postfix

local tex           = require("lilleaila-snippets.helpers.tex")
local utils         = require("lilleaila-snippets.helpers.util")
local tasnip        = tex.tasnip
local _tasnip       = tex._tasnip
local masnip        = tex.masnip
local _masnip       = tex._masnip

M                   = {
  postfix({ trig = "/", name = "fraction", condition = tex.in_math, snippetType = "autosnippet" },
    fmta(
      [[\frac{<>}{<>}]],
      {
        d(1, utils.postfix_match), i(2)
      })),
  _masnip({ trig = "ft", name = "fraction teller" },
    fmta(
      [[
      \frac{<>}{<>}<>
    ]],
      {
        d(2, utils.get_visual),
        i(1),
        i(0)
      })),
  _masnip({ trig = "fn", name = "fraction nevner" },
    fmta(
      [[
      \frac{<>}{<>}<>
    ]],
      {
        i(1),
        d(2, utils.get_visual),
        i(0)
      })),
  masnip({ trig = "ff", name = "fraction" }, [[\frac{$1}{$2}]])
}

return M
