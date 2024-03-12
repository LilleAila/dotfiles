{ config, pkgs, lib, inputs, ... }:

{
	imports = [
    inputs.ags.homeManagerModules.default
  ];

	programs.ags = {
		enable = true;

		extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
	};

	home.file.".config/ags".source = pkgs.stdenv.mkDerivation {
		src = ./.;

		# TODO: autogenerate style/vars.scss from config.colorScheme.palette
		buildPhase = /* bash */ ''
		${pkgs.sass}/bin/sass ./style.scss ./style.css
		${pkgs.bun}/bin/bun build ./config.ts \
			--outfile config.js \
			--external "resource://*" \
      --external "gi://*"
		'';

		installPhase = /* bash */ ''
		mkdir -p $out
		cp -r * $out
		'';
	};
}
