{ lib, inputs, ... }:
{
  flake.modules.nixos.sound =
    {
      config,
      pkgs,
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
          wireplumber.enable = true;
        };

        user.extraGroups = [ "audio" ];

        security.pam.loginLimits = [
          {
            domain = "@audio";
            type = "-";
            item = "rtprio";
            value = "95";
          }
          {
            domain = "@audio";
            type = "-";
            item = "memlock";
            value = "unlimited";
          }
        ];

        musnix = {
          enable = true;
          rtcqs.enable = true;
        };

        environment.systemPackages = with pkgs; [
          pipewire.jack
        ];
      };
    };
}
