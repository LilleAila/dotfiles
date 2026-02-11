local ls = require("lilleaila-snippets.helpers.ls")
local s, t = ls.s, ls.t

local M = {
  s({ trig = "!init!", name = "New flake" }, { t([[
    {
      description = "A flake";

      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      };

      outputs =
        { nixpkgs, ... }@inputs:
        let
          lib = nixpkgs.lib;
          systems = lib.systems.flakeExposed;
          pkgsFor = lib.genAttrs systems (system: import nixpkgs { inherit system; });
          forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
        in
        {
          packages = forEachSystem (pkgs: { });

          devShells = forEachSystem (pkgs: {
            default = pkgs.mkShell {
              packages = with pkgs; [
                nixd
                nixfmt-rfc-style
                statix
              ];
            };
          });
        };
    }
    ]]) })
}

return M
