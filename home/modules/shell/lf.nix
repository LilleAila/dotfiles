{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  config = lib.mkIf config.settings.terminal.utils.enable {
    xdg.configFile."lf/icons".source = ./icons;
    programs.lf = {
      enable = true;
      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };

      keybindings = {
        "\\\"" = "";
        o = "";
        c = "mkdir";
        "." = "set hidden!";
        "`" = "mark-load";
        "\\'" = "mark-load";
        "<enter>" = "open";
        do = "dragon-out";
        "g~" = "gc";
        gh = "cd";
        "g/" = "/";
        ee = "editor-open";
        V = ''''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
      };

      commands = {
        dragon-out = ''%${pkgs.xdragon}/bin/xdragin -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        mkdir = ''
          ''${{
          	printf "Directory Name: "
          	read DIR
          	mkdir -p $DIR
          }}
        '';
      };

      extraConfig =
        let
          previewer = pkgs.writeShellScriptBin "pv.sh" ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5

            if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            		${lib.getExe config.programs.kitty.package} +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            		exit 1
            fi

            ${pkgs.pistol}/bin/pistol "$file"
          '';

          cleaner = pkgs.writeShellScriptBin "clean.sh" ''
            ${lib.getExe config.programs.kitty.package} +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
          '';
        in
        ''
          set cleaner ${cleaner}/bin/clean.sh
          set previewer ${previewer}/bin/pv.sh
        '';
    };
  };
}
