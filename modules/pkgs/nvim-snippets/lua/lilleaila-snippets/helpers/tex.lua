local ls = require("lilleaila-snippets.helpers.ls")
local s, parse = ls.s, ls.parse

local utils = require("lilleaila-snippets.helpers.util")
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local function in_nodes(node_types)
  local node = ts_utils.get_node_at_cursor()
  -- Traverse the node tree
  while node do
    local node_type = node:type()
    -- Lua has no `in` operator. Could use a "set" where { a = true, b = true } etc. instead?
    for _, t in ipairs(node_types) do
      if node_type == t then
        return true
      end
    end
    node = node:parent()
  end
  return false
end

local math_nodes = {
  "math_environment",  -- \begin{equation} \end{equation}
  "inline_formula",    -- $ $
  "displayed_equation" -- $$ $$
}

function M.in_math()
  return in_nodes(math_nodes)
end

function M.in_text()
  return not M.in_math()
end

-- math snippet
local math_formula_conditions = {
  condition = utils.and_condition({ M.in_math, utils.word }),
  show_condition = M.in_math,
  wordTrig = false,
}
M.msnip = ls.extend_decorator.apply(parse, math_formula_conditions)
M._msnip = ls.extend_decorator.apply(s, math_formula_conditions)
-- math autosnippet
local math_auto_conditions = {
  snippetType = "autosnippet",
  condition = utils.and_condition({ M.in_math, utils.word }),
  show_condition = M.in_math,
  hidden = true,
  wordTrig = false
}
M.masnip = ls.extend_decorator.apply(parse, math_auto_conditions)
M._masnip = ls.extend_decorator.apply(s, math_auto_conditions)

-- text snippet
local text_conditions = {
  condition = utils.and_condition({ M.in_text, utils.word }),
  show_condition = M.in_text,
  wordTrig = false
}
M.tasnip = ls.extend_decorator.apply(parse, text_conditions)
M._tasnip = ls.extend_decorator.apply(s, text_conditions)
-- text autosnippet
local text_auto_conditions = {
  snippetType = "autosnippet",
  condition = utils.and_condition({ M.in_text, utils.word }),
  show_condition = M.in_text,
  hidden = true,
  wordTrig = false
}
M.tasnip = ls.extend_decorator.apply(parse, text_auto_conditions)
M._tasnip = ls.extend_decorator.apply(s, text_auto_conditions)

return M
