{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file."Wallpapers/hyprland_wallpaper.png".source = with config.colorScheme.palette;
    pkgs.runCommand "wallpaper" {} ''
      canvas_width=1920
      canvas_height=1080

      line_colors=("${base08}" "${base09}" "${base0A}" "${base0B}" "${base0C}")
      num_lines=''${#line_colors[@]}
      line_height=$((250 / $num_lines))
      center_y=$((canvas_height / 2))

      circle_x=$((canvas_width * 8 / 10))
      circle_y=$center_y
      circle_radius=250
      circle_edge_x=$(($circle_x + $circle_radius))
      circle_fill="${base01}"
      circle_stroke="${base02}"
      circle_stroke_width=10

      logo_path="${./nixos_white.png}"
      logo_color="${base06}"
      logo_color_percent=100
      logo_image_width=$(${pkgs.imagemagick}/bin/identify -format "%w" "$logo_path")
      logo_image_height=$(${pkgs.imagemagick}/bin/identify -format "%h" "$logo_path")

      if [ "$logo_image_width" -ge "$logo_image_height" ]; then
      	logo_width=$(($circle_radius * 2 - 60))
      	# logo_height=$(($logo_width / $logo_image_width * $logo_image_height))
      	logo_height=$(echo "scale=2; $logo_width / $logo_image_width * $logo_image_height" | ${pkgs.bc}/bin/bc)
      	logo_height=$(printf "%.0f" "$logo_height")
      else
      	logo_height=$(($circle_radius * 17 / 10))
      	# logo_width=$(($logo_height / $logo_image_height * $logo_image_width))
      	logo_height=$(echo "scale=2; $logo_height / $logo_image_height * $logo_image_width" | ${pkgs.bc}/bin/bc)
      	logo_height=$(printf "%.0f" "$logo_height")
      fi

      logo_x=$((circle_x - logo_width / 2))
      logo_y=$((circle_y - logo_height / 2))

      # logo_size=$(($circle_radius * 17 / 10))
      # logo_x=$((circle_x - logo_size / 2))
      # logo_y=$((circle_y - logo_size / 2))

      # Background
      cmd=(
      	"${pkgs.imagemagick}/bin/convert"
      	"-size" "''${canvas_width}x''${canvas_height}"
      	"gradient:#${base01}-#${base00}"
      	"-noise" "2"
      	"-blur" "0x0.5"
      	"-channel" "A"
      	"-evaluate" "Multiply" "0.7"
      )

      # Lines
      cmd+=("-strokewidth" "$line_height")
      for ((i=0; i<num_lines; i++)); do
          color="''${line_colors[$i]}"
          y_position=$((center_y + i * line_height - (line_height * (num_lines - 1) / 2)))
          cmd+=("-stroke" "#$color" "-draw" "line 0,$y_position $canvas_width,$y_position")
      done

      # Circle
      cmd+=(
        "-strokewidth" "$circle_stroke_width"
      	"-stroke" "#$circle_stroke"
      	"-fill" "#$circle_fill"
      	# "-draw" "translate $circle_x,$circle_y circle 0,0 $circle_radius,0"
      	"-draw" "circle $circle_x,$circle_y $circle_edge_x,$circle_y"
      )

      # Logo
      cmd+=(
      	"+channel" "("
      		"$logo_path"  "-resize" "''${logo_width}x''${logo_height}"
      		"-fill" "#$logo_color" "-colorize" "$logo_color_percent%"
      		"-alpha" "on"
      	")"
      	"-geometry" "+$logo_x+$logo_y"
      	"-gravity" "NorthWest"
      	"-composite"
      )

      # cmd+=(
      # 	"-page" "+$logo_x+$logo_y"
      # 	"$logo_path"
      # 	"-flatten"
      # )

      # Export
      cmd+=("png:-")

      "''${cmd[@]}" > $out
    '';
}
