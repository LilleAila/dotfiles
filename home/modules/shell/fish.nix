{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options.settings.terminal.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkIf (config.settings.terminal.fish.enable) (
    lib.mkMerge [
      {
        programs.fish = {
          enable = true;
          functions.fish_user_key_bindings = ''
            fish_default_key_bindings -M insert
            fish_vi_key_bindings --no-erase insert
          '';
          functions.fish_prompt = ''
            if not set -q VIRTUAL_ENV_DISABLE_PROMPT
            		set -g VIRTUAL_ENV_DISABLE_PROMPT true
            end
            set_color yellow
            printf '%s' $USER
            set_color normal
            printf ' at '

            set_color magenta
            echo -n (prompt_hostname)
            set_color normal
            printf ' in '

            set_color $fish_color_cwd
            printf '%s' (prompt_pwd)
            set_color normal

            # Line 2
            echo
            if test -n "$VIRTUAL_ENV"
            		printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
            end
            printf '↪ '
            set_color normal
          '';
          shellInit = ''
            set fish_greeting
          '';
          interactiveShellInit = ''
            fish_vi_key_bindings
          '';
        };
      }
      # (lib.mkIf (config.settings.terminal.emulator.name == "kitty") {
      # 	programs.kitty.settings.shell = lib.mkForce (lib.getExe config.programs.fish.package);
      # })
    ]
  );
}
