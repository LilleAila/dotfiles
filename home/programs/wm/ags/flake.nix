{
  description = "A simple nix flake using flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {...} @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.devshell.flakeModule
      ];

      perSystem = {
        pkgs,
        system,
        lib,
        ...
      }: {
        devshells.default = {
          packages = with pkgs; [
            nil
            alejandra
            typescript
            nodePackages.typescript-language-server
            prettierd
            emmet-ls
            vscode-langservers-extracted
          ];
        };

        packages = {
          default = pkgs.stdenv.mkDerivation {
            src = ./.;
            name = "ags";

            buildPhase =
              /*
              bash
              */
              with inputs.nix-colors.colorSchemes.gruvbox-dark-medium.palette; ''
                cat << EOF > ./style/cols.scss
                \$base00: #${base00};
                \$base01: #${base01};
                \$base02: #${base02};
                \$base03: #${base03};
                \$base04: #${base04};
                \$base05: #${base05};
                \$base06: #${base06};
                \$base07: #${base07};
                \$base08: #${base08};
                \$base09: #${base09};
                \$base0A: #${base0A};
                \$base0B: #${base0B};
                \$base0C: #${base0C};
                \$base0D: #${base0D};
                \$base0E: #${base0E};
                \$base0F: #${base0F};
                EOF

                ${pkgs.sass}/bin/sass ./style.scss ./style.css
                ${lib.getExe pkgs.esbuild} config.ts \
                  --outfile=config.js \
                  --bundle \
                  --platform=neutral \
                  --target=es2017 \
                  --external:"resource://*" \
                  --external:"gi://*"
              '';

            installPhase =
              /*
              bash
              */
              ''
                mkdir -p $out
                mkdir -p $out/bin
                cp -r * $out

                cat << EOF > $out/bin/ags
                ags -c $out/config.js -b ags-testing
                EOF
                chmod +x $out/bin/ags
              '';
          };
        };
      };
    };
}
