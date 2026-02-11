local ls = require("lilleaila-snippets.helpers.ls")
local tex = require("lilleaila-snippets.helpers.tex")
local utils = require("lilleaila-snippets.helpers.util")
local tasnip = tex.tasnip
local _tasnip = tex._tasnip
local masnip = tex.masnip
local _masnip = tex._masnip
local msnip = tex.msnip
local _msnip = tex._msnip

return {
  msnip({ trig = "kv1", descr = "Første kvadratsetning" }, [[
    \left( $1 + $2 \right) ^{2} = $1 ^{2} + 2 \cdot  $1 \cdot $2 + $2 ^{2}
  ]]),
  msnip({ trig = "kv2", descr = "Andre kvadratsetning" }, [[
    \left( $1 - $2 \right) ^{2} = $1 ^{2} - 2 \cdot  $1 \cdot $2 + $2 ^{2}
  ]]),
  msnip({ trig = "kv3", descr = "Tredje kvadratsetning / konjugatsetningen" }, [[
    \left( $1 + $2 \right) \left( $1 - $2 \right) = $1 ^{2} - $2 ^{2}
  ]]),
  msnip({ trig = "abc", descr = "ABC-formelen" }, [[
    x = \frac{-$2 \pm \sqrt{$2^{2} - 4 \cdot $1 \cdot $3}}{2 \cdot $1}
  ]]),
  msnip({ trig = "fsina", descr = "Sinussetningen med sinus i nevner" }, [[
    \frac{$1}{\sin{$1}} = \frac{$2}{\sin{$2}} = \frac{$3}{\sin{$3}}
  ]]),
  msnip({ trig = "fsinb", descr = "Sinussetningen med sinus i teller" }, [[
    \frac{\sin{$1}}{$1} = \frac{\sin{$2}}{$2} = \frac{\sin{$3}}{$3}
  ]]),
  msnip({ trig = "fcos", descr = "Cosinussetningen" }, [[
    $1 ^{2} = $2 ^{2} + $3 ^{2} - 2 \cdot $2 \cdot $3 \cos{$4}
  ]]),
  msnip({ trig = "fder", descr = "Definisjonen av den deriverte" }, [[
    \lim_{ h \to 0 } \frac{ f \left( x + h \right) - f \left( x \right) }{h}
  ]]),
  msnip({ trig = "dprod", descr = "Derivasjon av produkt" }, [[
    \left( $1 \right)' \left( $2 \right) + \left( $1 \right) \left( $2 \right)'
  ]]),
  msnip({ trig = "ddiv", descr = "Derivasjon av brøk" }, [[
    \frac{\left( $1 \right)' \left( $2 \right) - \left( $1 \right) \left( $2 \right)'}{\left( $2 \right) ^{2}}
  ]])
}
