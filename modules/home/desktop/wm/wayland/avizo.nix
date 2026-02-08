{ self, lib, ... }:
{
  flake.modules.homeManager.avizo =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      options.settings.wm.avizo.enable = lib.mkEnableOption "avizo";

      config = lib.mkIf config.settings.wm.avizo.enable {
        # TODO: rewrite in ags
        services.avizo = {
          enable = true;
          package = pkgs.avizo;
          settings.default = {
            time = 1.0;
            width = 160;
            height = 160;
            padding = 12;
            y-offset = 0.9;
            border-radius = 16;
            border-width = 3;
            block-height = 10;
            block-spacing = 2;
            block-count = 10;
            fade-in = 0.2;
            fade-out = 0.2;
            background = "#${self.colorScheme.palette.base03}";
            bar-bg-color = "#${self.colorScheme.palette.base02}";
            border-color = "#${self.colorScheme.palette.base05}";
            bar-fg-color = "#${self.colorScheme.palette.base05}";
          };
        };
      };
    };
}
