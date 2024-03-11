{ config, pkgs, inputs, lib, ... }:

{
	programs.discocss = {
		enable = true;
		package = pkgs.discocss;
		discordPackage = pkgs.webcord-vencord;
		discordAlias = true;
	};
}
