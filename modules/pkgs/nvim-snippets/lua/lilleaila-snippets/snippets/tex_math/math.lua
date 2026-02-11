local ls = require("lilleaila-snippets.helpers.ls")
local d, i, fmta = ls.d, ls.i, ls.fmta
local postfix = ls.postfix

local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip
local msnip = tex.masnip
local _msnip = tex._masnip

M = {
  masnip({ trig = "tt", name = "Text" }, [[\text{$1}]]),

  -- align-environments
  -- for some reason \\ expands to \ even when it's inside [[]] /shrug
  masnip({ trig = "nn", name = "newline" }, [[
    \\\\
    $1&$2 & $0
  ]]),

  msnip({ trig = "lim", descr = "Limit" }, [[\lim_{$1 \to $2}]]),
  msnip({ trig = "lx", descr = "Limit" }, [[\lim_{x \to $1}]]),
  msnip({ trig = "li", descr = "Limit" }, [[\lim_{x \to \infty}]]),
  msnip({ trig = "l0", descr = "Limit" }, [[\lim_{x \to 0}]]),

  masnip({ trig = "*", name = "multiplication" }, [[\cdot]]),
  _masnip({ trig = "^", name = "exponent", condition = tex.in_math }, fmta([[^{<>}]], { d(1, utils.get_visual) })),
  _masnip({ trig = "_", name = "subscript", condition = tex.in_math }, fmta([[_{<>}]], { d(1, utils.get_visual) })),
  _masnip({ trig = "su", name = "underset" }, fmta([[\underset{<>}{<>}]], { i(1), d(2, utils.get_visual) })),
  _masnip({ trig = "so", name = "overset" }, fmta([[\overset{<>}{<>}]], { i(1), d(2, utils.get_visual) })),
  _masnip({ trig = "bo", name = "overbrace" }, fmta([[\overbrace{<>}^{<>}]], { d(1, utils.get_visual), i(2) })),
  _masnip({ trig = "bu", name = "underbrace" }, fmta([[\underbrace{<>}_{<>}]], { d(1, utils.get_visual), i(2) })),
  _masnip({ trig = "ss", name = "square root" }, fmta([[\sqrt{<>}]], { d(1, utils.get_visual) })),
  _masnip({ trig = "sr", name = "nth root" }, fmta([=[\sqrt[<>]{<>}]=], { i(1), d(2, utils.get_visual) })),
  masnip({ trig = "!=", name = "not equal" }, [[\neq]]),
  masnip({ trig = ">=", name = "greater than or equal" }, [[\geq]]),
  masnip({ trig = "<=", name = "less than than or equal" }, [[\leq]]),
  masnip({ trig = "ln", name = "Natural logarithm" }, [[\ln{$1}]]),
  masnip({ trig = "lg", name = "10-logarithm" }, [[\lg{$1}]]),
  masnip({ trig = "log", name = "Logarithm" }, [[\log_{$1}]]),
  _masnip({ trig = "vv", name = "Vector" }, fmta([[\vec{<>}]], { d(1, utils.get_visual) })),
  _masnip({ trig = "sin", name = "Sine" }, fmta([[\sin{<>}]], { d(1, utils.get_visual) })),
  _masnip({ trig = "cos", name = "Cosine" }, fmta([[\cos{<>}]], { d(1, utils.get_visual) })),
  masnip({ trig = "==", name = "Is equal?" }, [[\overset{?}{=}]]),

  msnip("pm", [[\pm]]),
  msnip("in", [[\in]]),
  msnip("notin", [[\notin]]),
  msnip("forall", [[\forall]]),
  msnip("ex", [[\exists]]),
  msnip("impl", [[\implies]]),
  msnip("iff", [[\iff]]),
  msnip("ø", [[\emptyset]]),
  msnip("oo", [[\infty]]),
  msnip("sm", [[\setminus]]),
  msnip("pi", [[\pi]]),
  msnip("perp", [[\perp]]),
  msnip("rarr", [[\rightarrow]]),
  msnip("larr", [[\leftarrow]]),
  msnip("Rarr", [[\Rightarrow]]),
  msnip("Larr", [[\Leftarrow]]),

  msnip("alpha", [[\alpha]]),
  msnip("Delta", [[\Delta]]),
  msnip("theta", [[\theta]]),

  postfix({ trig = "vv", name = "vector", condition = tex.in_math, snippetType = "autosnippet" },
    fmta(
      [[\vec{<>}]],
      {
        d(1, utils.postfix_match)
      })),

  postfix({ trig = "inv", name = "inverse function", condition = tex.in_math, snippetType = "autosnippet" },
    fmta(
      [[<>^{-1}]],
      {
        d(1, utils.postfix_match)
      })),

  postfix({ trig = "bb", name = "blackboard font", condition = tex.in_math, snippetType = "autosnippet" },
    fmta(
      [[\mathbb{<>}]],
      {
        d(1, utils.postfix_match)
      })),
}

return M
