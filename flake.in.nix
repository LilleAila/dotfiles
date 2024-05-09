{
  description = "NixOS config flake";

  inputs = import ./inputs.nix;

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
        }
    );

    globalSettings = {
      # Define username here. Probably a better way to do this
      username = "olai";
    };
    mkConfig = {
      name,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs globalSettings;};
        modules =
          [
            ./hosts/${name}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs globalSettings;
                  isNixOS = true;
                };
                useUserPackages = true;
                useGlobalPkgs = true;
                users."${globalSettings.username}" = ./home/${name}.nix;
              };
            }
            (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" globalSettings.username])
          ]
          ++ extraModules;
      };
  in {
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});

    nixosConfigurations = {
      mac-nix = mkConfig {
        name = "mac-nix";
        extraModules = [
          inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
        ];
      };

      oci-nix = mkConfig {
        name = "oci";
      };

      t420-nix = mkConfig {
        name = "t420";
        extraModules = [nixos-hardware.nixosModules.lenovo-thinkpad-t420];
      };

      legion-nix = mkConfig {
        name = "legion";
        extraModules = [nixos-hardware.nixosModules.common-cpu-intel];
      };
    };

    homeConfigurations."${globalSettings.username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Idk how to do but somehow make this also arm
      extraSpecialArgs = {
        inherit inputs outputs globalSettings;
      };

      modules = [
        {nixpkgs.overlays = [inputs.emacs-overlay.overlay];}
        ./home.nix
      ];
    };
  };
}
