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
    keys = import ./secrets/not-so-secrets.nix;

    defaultSettings = {
      # Define username here. Probably a better way to do this
      username = "olai";
    };
    mkConfig = {
      name,
      extraModules ? [],
      globalSettings ? defaultSettings,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs globalSettings keys;};
        modules =
          [
            ./hosts/${name}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs globalSettings keys;
                  isNixOS = true;
                };
                useUserPackages = true;
                useGlobalPkgs = true;
                backupFileExtension = "backup";
                users."${globalSettings.username}" = ./hosts/${name}/home.nix;
              };
            }
            (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" globalSettings.username])
          ]
          ++ extraModules;
      };
  in {
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs inputs;});
    devShells = forEachSystem (pkgs: {default = import ./shell.nix {inherit pkgs;};});

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

      e14g5-nix = mkConfig {
        name = "e14g5";
        extraModules = [nixos-hardware.nixosModules.common-cpu-amd nixos-hardware.nixosModules.common-gpu-amd];
      };

      installer = mkConfig {
        name = "installer";
        globalSettings.username = "nixos";
      };
    };

    homeConfigurations."${defaultSettings.username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Idk how to do but somehow make this also arm
      extraSpecialArgs = {
        inherit inputs outputs keys;
        globalSettings = defaultSettings;
      };

      modules = [
        {nixpkgs.overlays = [inputs.emacs-overlay.overlay];}
        ./home.nix
      ];
    };
  };
}
