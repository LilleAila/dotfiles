{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.settings.ollama;
in
{
  options.settings.ollama.enable = lib.mkEnableOption "ollama";

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };

    services.nextjs-ollama-llm-ui = {
      enable = true;
    };

    settings.persist.root.directories = [
      "/var/lib/ollama/models"
      # "/var/cache/nextjs-ollama-llm-ui"
    ];
  };
}
