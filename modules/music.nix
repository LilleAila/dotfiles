{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.modules.nixos.music = { config, pkgs, ... }: {
    config = lib.mkIf config.hm.settings.music.enable {
      # NOTE: this is a slightly janky way of installing, as it requires
      # first building without installing (to add the env vars)
      # and then building again with pianoteq added.
      # (at least i believe it does, that was what i did anyways)
      nix.envVars =
        let
          credentials = self.secrets.pianoteq;
        in
        {
          NIX_MODARTT_USERNAME = credentials.username;
          NIX_MODARTT_PASSWORD = credentials.password;
        };
    };
  };

  flake.modules.homeManager.music =
    { config, pkgs, ... }:
    let
      cfg = config.settings.music;

      # Temp due to libdisplay info version issues
      pkgs' = import inputs.nixpkgs-unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "pianoteq-standard"
          ];
      };
    in
    {
      options.settings.music.enable = lib.mkEnableOption "music";

      config = lib.mkIf cfg.enable {
        settings.nix.unfree = [ "pianoteq-standard" ];

        settings.persist.home.cache = [
          ".config/Modartt"
          ".local/share/Modartt"
        ];

        home.packages = with pkgs; [
          # pianoteq.standard_9
          pkgs'.pianoteq.standard_9
          neural-amp-modeler-lv2
          ardour
          carla
        ];
      };
    };
}
