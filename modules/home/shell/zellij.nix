{ self, lib, ... }:
{
  flake.modules.homeManager.zellij =
    {
      inputs,
      pkgs,
      config,
      ...
    }:
    {
      config = lib.mkIf config.settings.terminal.utils.enable (
        lib.mkMerge [
          {
            programs.zellij = {
              enable = true;
              settings = {
                # copy_command = lib.getExe' pkgs.wl-clipboard "wl-copy"; # FIXME: only on wayland
                # copy_clipboard = "system";
                copy_on_select = false;
                session_serialization = true; # Save sessions
                pane_viewport_serialization = true;
                scrollback_lines_to_serialize = 100;
                ui.pane_frames.rounded_corners = true;

                themes.${self.colorScheme.slug} =
                  let
                    c = self.colorScheme.palette;
                  in
                  {
                    fg = "#${c.base06}";
                    bg = "#${c.base00}";
                    red = "#${c.base08}";
                    green = "#${c.base0B}";
                    yellow = "#${c.base0A}";
                    blue = "#${c.base0D}";
                    magenta = "#${c.base0E}";
                    orange = "#${c.base0F}";
                    cyan = "#${c.base0C}";
                    black = "#${c.base01}";
                    white = "#${c.base05}";
                  };
                theme = self.colorScheme.slug;
              };
            };
            home.shellAliases = {
              zj = "zellij";
            };
          }
          # (lib.mkIf (config.settings.terminal.emulator.name == "kitty") {
          #   programs.kitty.settings.shell = ''
          #     ${lib.getExe config.programs.zellij.package}
          #   '';
          # })
        ]
      );
    };
}
