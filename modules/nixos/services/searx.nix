# TODO: maybe move this to searx.olai.dev and have it publicly hosted instead of hosting it locally on each machine
{ lib, ... }:
{
  flake.modules.nixos.searx =
    {
      pkgs,
      inputs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.settings.searx;
    in
    {
      options.settings.searx.enable = lib.mkEnableOption "searx";

      config = lib.mkIf cfg.enable {
        sops.secrets."searx/env" = {
          owner = "searx";
          group = "searx";
        };
        services.searx = {
          enable = true;
          environmentFile = config.sops.secrets."searx/env".path;
          settings = {
            server = {
              port = 6969;
              default_locale = "en";
              secret_key = "@SEARX_SECRET_KEY@";
            };
            outgoing = {
              request_timeout = 2.0;
            };
          };
        };
      };
    };
}
