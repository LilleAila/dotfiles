{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  options.settings.nix = {
    enable = lib.mkDisableOption "nix";
    unfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of allowed unfree package names, usually defined in allowUnfreePredicate.";
    };
  };
  config = lib.mkIf config.settings.nix.enable {
    nixpkgs.config =
      let
        unfreePkgs =
          config.settings.nix.unfree
          ++ config.home-manager.users.${config.settings.user.name}.settings.nix.unfree;
      in
      {
        allowUnsupportedSystem = true;
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePkgs;
      };

    # Extending lib instead
    # _module.args.util = pkgs.callPackage ../lib {};
    # _module.args.util = import ../lib lib;

    nix = {
      optimise.automatic = true;

      gc = {
        automatic = true;
        options = "--keep 5 --nogcroots";
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        access-tokens = "github.com=${(import ../../secrets/tokens.nix).github}";

        substituters = [
          "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
          "https://anyrun.cachix.org"
          "https://nix-community.cachix.org"
          "https://yazi.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4"
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        ];
      };

      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [
        "nixpkgs=/etc/nixpkgs/channels/nixpkgs"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };

    systemd.tmpfiles.rules = [ "L+ /etc/nixpkgs/channels/nixpkgs - - - - ${pkgs.path}" ];

    environment.etc."programs.sqlite".source =
      inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
    programs.command-not-found = {
      enable = true;
      dbPath = "/etc/programs.sqlite";
    };
  };
}
