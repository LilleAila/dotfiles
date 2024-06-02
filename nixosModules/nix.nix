{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.settings.nix = {
    enable = lib.mkDisableOption "nix";
    unfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of allowed unfree package names, usually defined in allowUnfreePredicate.";
    };
  };
  config = lib.mkIf config.settings.nix.enable {
    nixpkgs.config = let
      unfreePkgs = config.settings.nix.unfree ++ config.home-manager.users.${config.settings.user.name}.settings.nix.unfree;
    in {
      allowUnsupportedSystem = true;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) unfreePkgs;
    };

    # Extending lib instead
    # _module.args.util = pkgs.callPackage ../lib {};
    # _module.args.util = import ../lib lib;

    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];

        access-tokens = "github.com=${builtins.readFile ../secrets/github-token.txt}";

        substituters = [
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

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
