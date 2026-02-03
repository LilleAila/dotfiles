{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.nix =
    {
      config,
      pkgs,
      ...
    }:
    {
      options.settings.nix = {
        enable = self.lib.mkDisableOption "nix";
        unfree = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of allowed unfree package names, usually defined in allowUnfreePredicate.";
        };
      };
      config = lib.mkIf config.settings.nix.enable {
        nixpkgs.config =
          let
            unfreePkgs = config.settings.nix.unfree ++ config.hm.settings.nix.unfree;
          in
          {
            allowUnsupportedSystem = true;
            allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePkgs;
          };

        nix = {
          package = pkgs.nixVersions.latest;

          optimise.automatic = true;

          gc = {
            automatic = false; # too resource intensive
            # options = "--keep 5 --nogcroots";
          };

          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];

            warn-dirty = false;

            access-tokens = "github.com=${self.secrets.tokens.github}";

            substituters = [
              "https://hyprland.cachix.org"
              "https://nix-gaming.cachix.org"
              "https://nix-community.cachix.org"
              "https://tweag-jupyter.cachix.org"
            ];
            trusted-public-keys = [
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4"
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
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
          inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;
        programs.command-not-found = {
          enable = true;
          dbPath = "/etc/programs.sqlite";
        };
      };
    };
}
