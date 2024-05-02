{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.nix = {
    enable = lib.mkEnableOption "nix" // {default = true;};
    unfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of allowed unfree package names, usually defined in allowUnfreePredicate.";
    };
  };
  config = lib.mkIf config.settings.nix.enable {
    nixpkgs.config = {
      allowUnsupportedSystem = true;
      # allowUnfree = true; # Nuh uh
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) config.settings.nix.unfree;
    };

    nix = {
      settings.experimental-features = ["nix-command" "flakes"];

      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [
        "nixpkgs=/etc/nixpkgs/channels/nixpkgs"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };

    systemd.tmpfiles.rules = [
      "L+ /etc/nixpkgs/channels/nixpkgs - - - - ${pkgs.path}"
    ];

    environment.etc."programs.sqlite".source = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
    programs.command-not-found = {
      enable = true;
      dbPath = "/etc/programs.sqlite";
    };
  };
}
