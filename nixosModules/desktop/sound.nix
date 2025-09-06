{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.settings.sound.enable = lib.mkEnableOption "sound";

  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  config = lib.mkIf config.settings.sound.enable {
    settings.persist.home.cache = [ ".local/state/wireplumber" ];
    settings.persist.root.cache = [ "/var/lib/alsa" ]; # alsa-store.service was complaining or something

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    musnix = {
      enable = true;
      rtcqs.enable = true;
    };
  };
}
