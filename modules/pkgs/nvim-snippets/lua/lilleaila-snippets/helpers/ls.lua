local M = {}

local ls = require("luasnip")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt")

M.ls = ls
M.extras = extras
M.s = ls.snippet
M.sn = ls.snippet_node
M.isn = ls.indent_snippet_node
M.t = ls.text_node
M.i = ls.insert_node
M.f = ls.function_node
M.c = ls.choice_node
M.d = ls.dynamic_node
M.r = ls.restore_node
M.l = extras.lambda
M.events = require("luasnip.util.events")
M.ai = require("luasnip.nodes.absolute_indexer")
M.extras = require("luasnip.extras")
M.rep = extras.rep
M.p = extras.partial
M.m = extras.match
M.n = extras.nonempty
M.dl = extras.dynamic_lambda
M.fmt = fmt.fmt
M.fmta = fmt.fmta
M.conds = require("luasnip.extras.expand_conditions")
M.postfix = require("luasnip.extras.postfix").postfix
M.types = require("luasnip.util.types")
M.parse = require("luasnip.util.parser").parse_snippet
M.ms = ls.multi_snippet
M.extend_decorator = ls.extend_decorator

return M
