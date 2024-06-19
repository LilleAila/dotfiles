{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings.sound.enable = lib.mkEnableOption "sound";

  config = lib.mkIf config.settings.sound.enable {
    settings.persist.home.cache = [".local/state/wireplumber"];
    settings.persist.root.cache = ["/var/lib/alsa"]; # alsa-store.service was complaining or something

    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
