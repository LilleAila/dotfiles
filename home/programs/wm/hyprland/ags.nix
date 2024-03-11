{ config, pkgs, lib, inputs, ... }:

{
	imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
		sass
	];

	programs.ags = {
		enable = true;

		extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
	};

	# Manually managed
# 	xdg.configFile."ags" = {
# 		source = ./ags;
# 		recursive = true;
# 	};
#
# 	# Something like this for color scheme
# 	xdg.configFile."ags/style/vars.scss".text = with config.colorScheme.palette; /*scss*/ ''
# $base00: #${base00}; /* ---- */
# $base01: #${base01}; /* --- */
# $base02: #${base02}; /* -- */
# $base03: #${base03}; /* - */
# $base04: #${base04}; /* + */
# $base05: #${base05}; /* ++ */
# $base06: #${base06}; /* +++ */
# $base07: #${base07}; /* ++++ */
# $base08: #${base08}; /* red */
# $base09: #${base09}; /* orange */
# $base0A: #${base0A}; /* yellow */
# $base0B: #${base0B}; /* green */
# $base0C: #${base0C}; /* aqua/cyan */
# $base0D: #${base0D}; /* blue */
# $base0E: #${base0E}; /* purple */
# $base0F: #${base0F}; /* brown */
#
# $bar_bg: rgba($base00, 0.1);
# $bg: $base01;
# $bg_alt: $base02;
# $bg_alt2: $base04;
# $fg: $base07;
#
# $bar_height: 32px;
# $item_height: 24px; /* I don't think this is used at all */
# 	'';
}
