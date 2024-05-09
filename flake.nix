# Do not modify! This file is generated.

{
  description = "NixOS config flake";
  inputs = {
    ags = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Aylur/ags";
    };
    emacs-overlay = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/emacs-overlay";
    };
    firefox-addons = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flakegen.url = "github:jorsn/flakegen";
    gross = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:fufexan/gross";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.40.0&submodules=1";
    hyprlock = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hyprwm/hyprlock";
    };
    hyprpaper = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hyprwm/hyprpaper";
    };
    hyprpicker = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hyprwm/hyprpicker";
    };
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:viperML/nh";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nix-cursors = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LilleAila/nix-cursors";
    };
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/nix-index-database";
    };
    nixos-apple-silicon = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:tpwrules/nixos-apple-silicon";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim-config.url = "github:LilleAila/nvim-nix";
    plover-flake.url = "github:LilleAila/plover-flake/wayland-support";
    programsdb = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wamserma/flake-programs-sqlite";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    wrapper-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:viperML/wrapper-manager";
    };
  };
  outputs = inputs: inputs.flakegen ./flake.in.nix inputs;
}