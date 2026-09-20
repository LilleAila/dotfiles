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
    {
      config,
      pkgs,
      osConfig, # NOTE: using this is not very good practive, but it works fine
      ...
    }:
    let
      cfg = config.settings.music;

      # Temp due to libdisplay-info version issues
      pkgs' = import inputs.nixpkgs-unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "pianoteq-standard"
          ];
      };

      # Wrapped to run with `pw-jack`, which makes JACK output work properly through the pipewire compatibility layer
      pianoteq-jack =
        let
          pianoteq = pkgs'.pianoteq.standard_9;
        in
        pkgs.symlinkJoin {
          name = "pianoteq-wrapped-${pianoteq.version}";
          paths = [ pianoteq ];
          postBuild = ''
            rm "$out/bin/Pianoteq 9"
            cat << 'EOF' > "$out/bin/Pianoteq 9"
            #!${pkgs.runtimeShell}
            exec "${lib.getExe' osConfig.services.pipewire.package.jack "pw-jack"}" "${lib.getExe pianoteq}" "$@"
            EOF
            chmod +x "$out/bin/Pianoteq 9"
          '';
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
          # pkgs'.pianoteq.standard_9
          pianoteq-jack
          neural-amp-modeler-lv2
          ardour
          carla
          qpwgraph
        ];
      };
    };
}
