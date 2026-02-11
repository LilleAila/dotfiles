local ls = require("lilleaila-snippets.helpers.ls")
local t, i, sn = ls.t, ls.i, ls.sn

M = {}

-- AND a list of functions to be used as a condition
-- `and` is a reserved keyword
function M.and_condition(functions)
  return function(line_to_cursor, matched_trigger, captures)
    for _, func in ipairs(functions) do
      if not func(line_to_cursor, matched_trigger, captures) then
        return false
      end
    end
    return true
  end
end

-- OR a list of functions to be used as a condition
function M.or_condition(functions)
  return function(line_to_cursor, matched_trigger, captures)
    for _, func in ipairs(functions) do
      if func(line_to_cursor, matched_trigger, captures) then
        return true
      end
    end
    return false
  end
end

-- Get text from pressing <tab>
-- Something like this would also work: https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/luasnip-latex-snippets/math_i.lua#L43
function M.get_visual(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return ls.sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return ls.sn(nil, i(1))
  end
end

function M.get_cap(index)
  return ls.f(function(_, snip)
    return snip.captures[index]
  end)
end

-- M.line_begin = require("luasnip.extras.expand_conditions").line_begin

function M.word(line_to_cursor, match)
  local from = #line_to_cursor - #match + 1
  local prefix = string.sub(line_to_cursor, from - 1, from - 1)
  return from == 1 or string.match(prefix, "[^%s${}]") == nil
end

function M.postfix_match(_, parent)
  return sn(nil, { t(parent.env.POSTFIX_MATCH) })
end

-- autosnippet
M.asnip = ls.extend_decorator.apply(ls.s, { snippetType = "autosnippet" })

return M
