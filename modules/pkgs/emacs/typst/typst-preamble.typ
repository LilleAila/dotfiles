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

#let da = $dif a$
#let db = $dif b$
#let dc = $dif c$
#let dd = $dif d$
#let de = $dif e$
#let df = $dif f$
#let dg = $dif g$
#let dh = $dif h$
#let di = $dif i$
#let dj = $dif j$
#let dk = $dif k$
#let dl = $dif l$
#let dm = $dif m$
#let dn = $dif n$
#let do = $dif o$
#let dp = $dif p$
#let dq = $dif q$
#let dr = $dif r$
#let ds = $dif s$
#let dt = $dif t$
#let du = $dif u$
#let dv = $dif v$
#let dw = $dif w$
#let dx = $dif x$
#let dy = $dif y$
#let dz = $dif z$
#let dA = $dif A$
#let dB = $dif B$
#let dC = $dif C$
#let dD = $dif D$
#let dE = $dif E$
#let dF = $dif F$
#let dG = $dif G$
#let dH = $dif H$
#let dI = $dif I$
#let dJ = $dif J$
#let dK = $dif K$
#let dL = $dif L$
#let dM = $dif M$
#let dN = $dif N$
#let dO = $dif O$
#let dP = $dif P$
#let dQ = $dif Q$
#let dR = $dif R$
#let dS = $dif S$
#let dT = $dif T$
#let dU = $dif U$
#let dV = $dif V$
#let dW = $dif W$
#let dX = $dif X$
#let dY = $dif Y$
#let dZ = $dif Z$
