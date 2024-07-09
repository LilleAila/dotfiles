lib: rec {
  round = x: builtins.floor (x + 0.5);

  # Convert a font size in pixels to points, for example kitty font size
  toPx = pts: round (pts * 4 / 3);
}
