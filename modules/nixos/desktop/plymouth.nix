{ self, lib, ... }:
{
  flake.modules.nixos.plymouth =
    {
      pkgs,
      inputs,
      config,
      outputs,
      ...
    }:
    {
      options.settings.plymouth.enable = lib.mkEnableOption "plymouth";

      config = lib.mkIf config.settings.plymouth.enable {
        boot.plymouth = {
          enable = true;
          theme = self.colorScheme.slug;
          themePackages = [
            (outputs.packages.${pkgs.stdenv.hostPlatform.system}.plymouth-theme.override {
              inherit (config.hm) colorScheme;
            })
          ];
        };
      };
    };
}
