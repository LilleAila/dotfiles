{ config, pkgs, lib, inputs, ... }:

{
	imports = [
    inputs.ags.homeManagerModules.default
  ];

	options.settings.wm.ags.enable = lib.mkEnableOption "ags";

	config = lib.mkIf (config.settings.wm.ags.enable) {
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
			name = "AGS configuration";

			buildPhase = /* bash */ with config.colorScheme.palette; ''
cat << EOF > ./style/cols.scss
\$base00: #${base00}; /* ---- */
\$base01: #${base01}; /* --- */
\$base02: #${base02}; /* -- */
\$base03: #${base03}; /* - */
\$base04: #${base04}; /* + */
\$base05: #${base05}; /* ++ */
\$base06: #${base06}; /* +++ */
\$base07: #${base07}; /* ++++ */
\$base08: #${base08}; /* red */
\$base09: #${base09}; /* orange */
\$base0A: #${base0A}; /* yellow */
\$base0B: #${base0B}; /* green */
\$base0C: #${base0C}; /* aqua/cyan */
\$base0D: #${base0D}; /* blue */
\$base0E: #${base0E}; /* purple */
\$base0F: #${base0F}; /* brown */
EOF

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

		systemd.user.services.ags = {
			Unit = {
				Description = "Aylur's GTK Shell";
				PartOf = [ "graphical-session.target" ];
			};

			Service = {
				# Dependencies have to be added manually to PATH
				Environment = "PATH=${lib.makeBinPath [
					pkgs.coreutils
					config.programs.hyprlock.package
					pkgs.systemd
				]}";
				ExecStart = "${config.programs.ags.package}/bin/ags";
				Restart = "on-failure";
			};

			Install.WantedBy = [ "graphical-session.target" ];
		};
	};
}
