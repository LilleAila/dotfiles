#let colorschemes = (
  "gruvbox": (
    base00: rgb("#282828"),
    base01: rgb("#3c3836"),
    base03: rgb("#665c54"),
    base05: rgb("#d5c4a1"),
    base06: rgb("#ebdbb2"),
  ),
  "basic": (
    base00: rgb("#ffffff"),
    base01: rgb("#eeeeee"),
    base03: rgb("#bbbbbb"),
    base05: rgb("#111111"),
    base06: rgb("#333333"),
  ),
)

#let c = colorschemes.at(colorscheme, default: colorschemes.gruvbox)

// For some reason, pandoc uses #horizontalrule instead of #line(length: 100%)
#let horizontalrule = line(length: 100%)

#set text(
  font: "DejaVu Sans",
  size: 10pt,
  lang: "nb",
  fill: c.base06,
)

#set line(stroke: c.base06)

#set par(
  leading: 0.65em,
  spacing: 1.4em,
)

#show heading: it => {
  v(1.5em, weak: true)
  it
  v(0.8em, weak: true)
}

#set page(
  paper: "a4",
  margin: (top: 4cm, bottom: 4cm, left: 1.5cm, right: 1.5cm),
  columns: 2,
  fill: c.base00,
  header: {
    grid(
      columns: (1fr, auto),
      [#title], align(right)[#author],
    )
    line(length: 100%)
  },
  footer: context {
    line(length: 100%)
    grid(
      columns: (1fr, auto),
      [#date], align(right)[#counter(page).display("1/1", both: true)],
    )
  },
)

#show raw: set text(font: "JetBrainsMono NF")
#show raw.where(block: true): x => block(
  fill: c.base01,
  stroke: 1pt + c.base03,
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  {
    set par(
      hanging-indent: 1.5em,
      leading: 0.6em,
    )
    x
  },
)
#show raw.where(block: false): x => {
  h(1pt)
  box(
    fill: c.base01,
    stroke: 1pt + c.base03,
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
    x,
  )
  h(1pt)
}

#let _pseudocode-list = pseudocode-list
#let pseudocode-list(..args) = block(
  fill: c.base01,
  stroke: 1pt + c.base03,
  inset: (x: 10pt, y: 0pt),
  radius: 4pt,
  width: 100%,
  _pseudocode-list(..args)
)

#align(center)[
  #v(1em)
  #text(size: 16pt, weight: "bold")[#title]

  #text(size: 10pt)[#author]

  #text(size: 8pt, fill: c.base05)[#date]
  #v(1em)
]
