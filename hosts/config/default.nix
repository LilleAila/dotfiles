{ config, pkgs, inputs, lib, ... }:

{
	imports = [
		./greeter.nix
		./xserver.nix
		./locale.nix
		./user.nix
		./networking.nix
		./utils.nix
		./tlp.nix
		./asahi
		./console.nix
	];
}
