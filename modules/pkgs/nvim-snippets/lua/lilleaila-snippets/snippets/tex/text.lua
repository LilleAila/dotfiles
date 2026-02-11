local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip

local M = {
  tasnip({ trig = "!init!", name = "initialize new document" }, [[
    \newcommand*{\shared}{../shared}
    \input{\shared/p-document.tex}

    \title{$1}
    \date{$2}
    \author{Olai Solsvik}

    \begin{document}
    \maketitle
    \tableofcontents
    \hr

    $3

    \end{document}
  ]])
}

return M
