{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.wm.hyprland.screenshots.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  # TODO: fix cursor in screenshots (switch to grim+slurp directly??)
  config = let
    format = "%Y-%m-%d,%H:%M:%S.png";
    args = "--notify --freeze";
    # TODO: as of right now, this folder needs to be created manually
    path = "$HOME/Screenshots/Raw/$(date +\"${format}\")";
  in
    lib.mkIf (config.settings.wm.hyprland.screenshots.enable)
    {
      home.packages = with pkgs; [
        grim
        slurp
        grimblast
        swappy
        wl-clipboard
      ];

      # Configure swappy (screenshot annotation tool)
      home.file.".config/swappy/config".text = ''
        [Default]
        save_dir=$HOME/Screenshots/Edited
        save_filename_format=${format}
        show_panel=false # Show panel on start
        early_exit=true # Exit on export
        line_size=5
        text_size=20
        text_font=sans-serif
        paint_mode=brush
        fill_shape=false
      '';

      /*
      AAA HOW DO YTOU TAKE SCRENHOT WITHOUR COSOR??????
      slurp | grim -g - - | convert - -shave 2x2 PNG:- | swappy -f -
      grim -g "$(slurp)" - | convert - -shave 2x2 PNG:- | swappy -f -
      */

      # Configure keybindings
      wayland.windowManager.hyprland.settings = {
        bind = [
          "$mainMod SHIFT, E, exec, wl-paste | swappy -f -"
          "$mainMod, S, exec, grimblast ${args} copysave area ${path}"
          "$mainMod SHIFT, S, exec, grimblast ${args} copysave active ${path}"
          ", PRINT, exec, grimblast ${args} copysave output ${path}"
          "SHIFT, PRINT, exec, grimblast ${args} copysave screen ${path}"
          # Same as two above but without PrtSc
          "$mainMod ALT, S, exec, grimblast ${args} copysave output ${path}"
          "$mainMod ALT SHIFT, S, exec, grimblast ${args} copysave screen ${path}"
        ];
      };
    };
}
