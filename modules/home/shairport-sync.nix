# It seems like it only works with pipewire when running as a user service in systemd, so i have re-implemented the nixos module for home-manager.
{ lib, ... }: {
  flake.modules.nixos.shairport-sync =
    { pkgs, config, ... }:
    let
      cfg = config.settings.shairport-sync;
      configFormat = pkgs.formats.libconfig { };
    in
    {
      options = {
        settings.shairport-sync = {
          enable = lib.mkEnableOption "shairport-sync";
          name = lib.mkOption {
            type = lib.types.str;
          };
        };
      };

      config = lib.mkIf cfg.enable {
        settings.sound.enable = lib.mkDefault true;

        hm.systemd.user.services.shairport-sync =
          let
            config-file = configFormat.generate "shairport-sync.conf" {
              general = {
                inherit (cfg) name;
                output_backend = "pipewire";
                diagnostics.log_verbosity = 1;
              };

              pipewire = {
                latency_offset = 0;
                output_rate = 44100;
                output_format = "S16";
              };
            };
          in
          {
            Unit = {
              Description = "shairport-sync";
              After = [
                "graphical-session.target"
                "pipewire.service"
              ];
            };

            Service = {
              ExecStart = "${lib.getExe pkgs.shairport-sync} -c ${config-file}";
              Restart = "on-failure";
            };
          };

        networking.firewall = {
          allowedTCPPorts = [ 5000 ];
          allowedUDPPortRanges = [
            {
              from = 6001;
              to = 6011;
            }
          ];
        };

      };
    };
}
