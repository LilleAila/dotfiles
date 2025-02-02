{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.settings.distrobox.enable = lib.mkEnableOption "distrobox";

  config = lib.mkIf config.settings.distrobox.enable (
    # FIXME: remove docker, only use podman.dockerCompat
    lib.mkAssert (!config.settings.docker.enable) "Cannot use both podman and docker!" {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      environment.systemPackages = with pkgs; [
        distrobox
      ];

      settings.persist.home.cache = [
        ".local/share/containers"
      ];
    }
  );
}
