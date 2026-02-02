{ self, lib, ... }:
{
  flake.modules.homeManager.btop =
    {
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.settings.terminal.utils.enable {
        programs.btop = {
          enable = true;
          settings = {
            color_theme = "${self.colorScheme.slug}";
          };
        };

        xdg.configFile."btop/themes/${self.colorScheme.slug}.theme".text = with self.colorScheme.palette; ''
          theme[main_bg]="#${base00}"
          theme[main_fg]="#${base05}"
          theme[title]="#${base05}"
          theme[hi_fg]="#${base0D}"
          theme[selected_bg]="#${base03}"
          theme[selected_fg]="#${base0D}"
          theme[inactive_fg]="#${base04}"
          theme[graph_text]="#${base06}"
          theme[meter_bg]="#${base03}"
          theme[proc_misc]="#${base06}"
          theme[cpu_box]="#${base0E}"
          theme[mem_box]="#${base0B}"
          theme[net_box]="#${base0C}"
          theme[proc_box]="#${base0D}"
          theme[div_line]="#${base01}"
          theme[temp_start]="#${base0B}"
          theme[temp_mid]="#${base0A}"
          theme[temp_end]="#${base08}"
          theme[cpu_start]="#${base0B}"
          theme[cpu_mid]="#${base0A}"
          theme[cpu_end]="#${base08}"
          theme[free_start]="#${base0B}"
          theme[free_mid]="#${base0A}"
          theme[free_end]="#${base08}"
          theme[cached_start]="#${base0B}"
          theme[cached_mid]="#${base0A}"
          theme[cached_end]="#${base08}"
          theme[available_start]="#${base0B}"
          theme[available_mid]="#${base0A}"
          theme[available_end]="#${base08}"
          theme[used_start]="#${base0B}"
          theme[used_mid]="#${base0A}"
          theme[used_end]="#${base08}"
          theme[download_start]="#${base0B}"
          theme[download_mid]="#${base0A}"
          theme[download_end]="#${base08}"
          theme[upload_start]="#${base0B}"
          theme[upload_mid]="#${base0A}"
          theme[upload_end]="#${base08}"
          theme[process_start]="#${base0B}"
          theme[process_mid]="#${base0A}"
          theme[process_end]="#${base08}"
        '';
      };
    };
}
