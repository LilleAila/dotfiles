#let template(title: "", author: "", date: "", doc) = [
  #set text(
    font: "DejaVu Sans",
    size: 10pt,
    lang: "nb",
  )

  #set page(
    paper: "a4",
    margin: (top: 4cm, bottom: 4cm, left: 1.5cm, right: 1.5cm),
    header: {
      grid(
        columns: (1fr, auto),
        [#name], align(right)[#author],
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
    fill: luma(245),
    stroke: 1pt + luma(200),
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
      fill: luma(240),
      stroke: 1pt + luma(200),
      inset: (x: 3pt),
      outset: (y: 3pt),
      radius: 2pt,
      x,
    )
    h(1pt)
  }


  #align(center)[
    #v(1em)
    #text(size: 14pt, weight: "bold")[#title]
    #v(1em)
    #text(size: 10pt)[#author]
    #v(2em)
  ]

  #doc
]
