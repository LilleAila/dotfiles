{ config, pkgs, inputs, lib, ... }:

{
	home.packages = with pkgs; [
		vesktop
	];

	 # TODO: i think the splash color has to be added here with nix-colors??
	home.file.".config/vesktop/settings.json".source = pkgs.writeText "settings.json" /* json */ ''
{
    "splashColor": "rgb(213, 196, 161)",
    "splashBackground": "rgb(40, 40, 40)",
    "minimizeToTray": false,
    "arRPC": true,
    "disableMinSize": true,
    "staticTitle": true,
    "splashTheming": true
}
	'';

	home.file.".config/vesktop/settings/settings.json".source = ./discord-settings.json;

	# Auto-generated color scheme, inspired by https://github.com/deathbeam/base16-discord
	# Slightly modified by changing theme variables in devtools (Ctrl + Shift + i)
	home.file.".config/vesktop/themes/base16.theme.css".source = with config.colorScheme.palette; pkgs.writeText "base16.theme.css" /* css */ ''
/**
* @name ${config.colorScheme.slug}
* @author LilleAila
* @version 1.0.0
* @description Base16 color scheme generated from https://github.com/Misterio77/nix-colors
**/

:root {
    --base00: #${base00}; /* Black */
    --base01: #${base01}; /* Bright Black */
    --base02: #${base02}; /* Grey */
    --base03: #${base03}; /* Brighter Grey */
    --base04: #${base04}; /* Bright Grey */
    --base05: #${base05}; /* White */
    --base06: #${base06}; /* Brighter White */
    --base07: #${base07}; /* Bright White */
    --base08: #${base08}; /* Red */
    --base09: #${base09}; /* Orange */
    --base0A: #${base0A}; /* Yellow */
    --base0B: #${base0B}; /* Green */
    --base0C: #${base0C}; /* Cyan */
    --base0D: #${base0D}; /* Blue */
    --base0E: #${base0E}; /* Purple */
    --base0F: #${base0F}; /* Magenta */

    --primary-630: var(--base00); /* Autocomplete background */
    --primary-660: var(--base00); /* Search input background */
}

.theme-light, .theme-dark {
    --search-popout-option-fade: none; /* Disable fade for search popout */
    --bg-overlay-2: var(--base00); /* These 2 are needed for proper threads coloring */
    --home-background: var(--base00);
    --background-primary: var(--base00);
    --background-secondary: var(--base00); /* --base01 */
    --background-secondary-alt: var(--base00); /* --base01 */
    --channeltextarea-background: var(--base01);
    --background-tertiary: var(--base00);
    --background-accent: var(--base0E);
    --background-floating: var(--base01);
    --background-modifier-selected: var(--base00);
    --text-normal: var(--base05);
    --text-secondary: var(--base00);
    --text-muted: var(--base03);
    --text-link: var(--base0C);
    --interactive-normal: var(--base05);
    --interactive-hover: var(--base0C);
    --interactive-active: var(--base0A);
    --interactive-muted: var(--base03);
    --header-primary: var(--base0B); /* --base06 */
    --header-secondary: var(--base04); /* --base03 */
    --scrollbar-thin-track: transparent;
    --scrollbar-auto-track: transparent;
}
	'';
}
