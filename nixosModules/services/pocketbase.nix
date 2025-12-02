{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.pocketbase;
in
{
  options.services.pocketbase = {
    enable = lib.mkEnableOption "pocketbase";
    user = lib.mkOption {
      type = lib.types.str;
      default = "pocketbase";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "pocketbase";
    };
    workingDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/pocketbase";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8090;
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isNormalUser = true;
      inherit (cfg) group;
    };

    systemd.services.pocketbase = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "Pocketbase backend";
      script = ''
        ${lib.getExe pkgs.pocketbase} serve --http ${cfg.host}:${builtins.toString cfg.port} --dir ${cfg.workingDirectory}
      '';
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.workingDirectory;
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.tmpfiles.rules = [
      "d ${cfg.workingDirectory} 0700 ${cfg.user} ${cfg.group} -"
    ];
  };
}
