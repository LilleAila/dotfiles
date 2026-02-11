local ls = require("lilleaila-snippets.helpers.ls")
local f, d, i, fmta = ls.f, ls.d, ls.i, ls.fmta
local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip

-- brackets
-- maybe rename to use characters instead of symbols?
local brackets = {
  ["p"] = { "(", ")" },     -- Parentheses
  ["b"] = { "[", "]" },     -- Brackets
  ["c"] = { "\\{", "\\}" }, -- Curly brackets
  ["<"] = { "\\langle", "\\rangle" },
  ["|"] = { "|", "|" },
  ["t"] = { "\\|", "\\|" },         -- Two pipes
  ["u"] = { "\\lceil", "\\rceil" }, -- round Up
  ["d"] = { "\\lfloor", "\\rfloor" }, -- round Down
  ["."] = { ".", "." },
}

local fallback_bracket = "p"

local function escapePattern(s)
  return s:gsub("([%.%%%+%-%*%?%[%]%^%$%(%)])", "%%%1")
end

local bracketsMatch = "([" .. table.concat(vim.tbl_map(escapePattern, vim.tbl_keys(brackets))) .. "])"

M = {
  _masnip({ trig = "lr" .. bracketsMatch, name = "Left and right equal delimiters", regTrig = true },
    fmta(
      [[
      \left<> <> \right<><>
    ]],
      {
        f(function(_, snip)
          local cap = snip.captures[1] or fallback_bracket
          return brackets[cap][1]
        end),
        d(1, utils.get_visual),
        f(function(_, snip)
          local cap = snip.captures[1] or fallback_bracket
          return brackets[cap][2]
        end),
        i(0)
      })),
  _masnip(
    { trig = "l" .. bracketsMatch .. "r" .. bracketsMatch, name = "Left and right non-equal delimiters", regTrig = true },
    fmta(
      [[
      \left<> <> \right<><>
    ]],
      {
        f(function(_, snip)
          local cap = snip.captures[1] or fallback_bracket
          return brackets[cap][1]
        end),
        d(1, utils.get_visual),
        f(function(_, snip)
          local cap = snip.captures[2] or fallback_bracket
          return brackets[cap][2]
        end),
        i(0)
      })),
}

return M
