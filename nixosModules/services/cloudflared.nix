{
  pkgs,
  lib,
  inputs,
  config,
  globalSettings,
  ...
}:
{
  options.settings.cloudflared.enable = lib.mkEnableOption "cloudflared";

  config = lib.mkIf config.settings.cloudflared.enable {
    sops.secrets."tunnels/cert" = {
      path = "/home/${config.settings.user.name}/.cloudflared/cert.pem";
      owner = config.settings.user.name;
    };

    settings.persist.home.directories = [ ".cloudflared" ];

    environment.systemPackages = [ pkgs.cloudflared ];

    # the above *could* be done in home-manager, but i prefer having it centralized
    services.cloudflared.enable = true;
  };
}
