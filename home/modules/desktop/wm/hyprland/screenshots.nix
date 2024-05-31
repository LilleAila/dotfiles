{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.settings.wm.hyprland.screenshots = {
    enable = lib.mkEnableOption "screenshots";
    path = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/Pictures/Screenshots";
    };
    format = lib.mkOption {
      type = lib.types.str;
      default = "%Y-%m-%d,%H:%M:%S.png";
    };
  };

  config = let
    cfg = config.settings.wm.hyprland.screenshots;
  in
    lib.mkIf (cfg.enable)
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
        save_dir=$XDG_SCREENSHOTS_DIR
        save_filename_format=${cfg.format}
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

      xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR = cfg.path;

      # Configure keybindings
      wayland.windowManager.hyprland.settings = {
        bind = let
          # cmd = "${lib.getExe pkgs.hyprshot} -o ${cfg.path} -f $(date +${cfg.format})";
          cmd = mode: "${lib.getExe pkgs.grimblast} --notify --freeze copysave ${mode} ${cfg.path}";
          paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
          copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
          magick = lib.getExe pkgs.imagemagick;
        in [
          "$mainMod, E, exec, ${paste} | ${lib.getExe pkgs.swappy} -f -"
          # Crop image in clipboard:
          "$mainMod SHIFT, E, exec, sh -c \"${paste} | ${magick} - -shave 2x2 PNG:- | ${copy}\""

          # Grimblast
          "$mainMod, S, exec, ${cmd "area"}"
          "$mainMod SHIFT, S, exec, ${cmd "active"}"
          "$mainMod ALT, S, exec, ${cmd "output"}"
          "$mainMod Alt SHIFT, S, exec, ${cmd "screen"}"

          # Using hyprshot
          # "$mainMod, S, exec, ${cmd} -m region"
          # "$mainMod SHIFT, S, exec, ${cmd} -m window -c"
          # "$mainMod ALT, S, exec, ${cmd} -m output -c"

          # ", PRINT, exec, ${cmd} -m region"
          # "SHIFT, PRINT, exec, ${cmd} -m window -c"
          # "ALT, PRINT, exec, ${cmd} -m output -c"
        ];
        env = [
          "GRIMBLAST_EDITOR,\"swappy -f\""
        ];
      };
    };
}
