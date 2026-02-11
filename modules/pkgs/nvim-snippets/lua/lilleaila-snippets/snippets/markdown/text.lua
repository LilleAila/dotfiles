local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip

local M = {
  tasnip({ trig = "cc", name = "code block" }, [[
    ```$1
    $2
    ```
  ]]),
  tasnip({ trig = "h1", name = "heading 1" }, [[# $1]]),
  tasnip({ trig = "h2", name = "heading 2" }, [[## $1]]),
  tasnip({ trig = "h3", name = "heading 3" }, [[### $1]]),
  tasnip({ trig = "h4", name = "heading 4" }, [[#### $1]]),
  tasnip({ trig = "h5", name = "heading 5" }, [[##### $1]]),
  tasnip({ trig = "h6", name = "heading 6" }, [[###### $1]]),
  tasnip({ trig = "qq", name = "quote" }, [[
    > "$1"

    \- $2
  ]]),
}

return M
