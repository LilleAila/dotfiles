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
