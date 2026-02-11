local ls = require("lilleaila-snippets.helpers.ls")
local s, i, fmta = ls.s, ls.i, ls.fmta

local M = {
  s("imfig", fmta([[
    figure(
      image("<>"),
      caption: [
        <>
      ],
    )
  ]], { i(1, "filename.png"), i(2, "caption") })),
  s("imgrid", fmta([[
    grid(
      columns: (<>),
      rows: <>,
      inset: <>,
      <>
    )
  ]], { i(1, "35%, 35%"), i(2, "6cm"), i(3, "4pt"), i(4) })),
  s("colorbox", fmta([[
    colorbox(title: "<>", color: "<>")[
      <>
    ]
  ]], { i(1, "title"), i(2, "green"), i(3, "content") })),
  s("center", fmta([[
    align(center)[<>]
  ]], { i(1) })),
  s("md", fmta([[
    $
      <>
    $
  ]], { i(1) })),
  s("mm", fmta([[
    $<>$
  ]], { i(1) }))
}

return M
