{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.settings.sound.enable = lib.mkEnableOption "sound";

  config = lib.mkIf config.settings.sound.enable {
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
