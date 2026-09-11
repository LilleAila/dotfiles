#import "@preview/lovelace:0.3.1": *

#let _pseudocode-list = pseudocode-list.with(
  hooks: 0.5em,
  // booktabs: true,
)
#let pseudocode-list(..args) = text(
  font: "JetBrainsMono NF",
  _pseudocode-list(..args)
)

#let gap = [- #v(0.2em)]

// Math stuff:
#let va = math.arrow
#let ub(x) = $upright(bold(#x))$
#let bmat(..xs) = $mat(..xs, delim: "[")$
#let dlim(x) = $display(lim_(#x))$
#let unit(u) = $upright(#u)$
