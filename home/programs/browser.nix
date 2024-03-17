{ config, pkgs, inputs, lib, ... }:

{
	options.settings.browser.firefox.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
	};

	config = lib.mkIf (config.settings.browser.firefox.enable) {
		programs.firefox = {
			enable = true;
			# package = pkgs.firefox;
			profiles.olai = {
				bookmarks = [
					{
						name = "Wikipedia";
						tags = [ "wiki" ];
						keyword = "wiki";
						url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
					}
					{
						name = "Toolbar";
						toolbar = true;
						bookmarks = [
							{
								name = "NixOS";
								url = "https://nixos.org";
							}
							{
								name = "NixOS wiki";
								tags = [ "wiki" "nix" ];
								url = "https://nixos.wiki/";
							}
						];
					}
				];

				search.default = "DuckDuckGo";

				search.engines = {
					"Nix Packages" = {
						urls = [{
							template = "https://search.nixos.org/packages?channel=unstable";
							params = [
								{ name = "type"; value = "packages"; }
								{ name = "query"; value = "{searchTerms}"; }
							];
						}];

						icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						definedAliases = [ "@np" ];
					};

					"Nix Options" = {
						urls = [{
							template = "https://search.nixos.org/options?channel=unstable";
							params = [
								{ name = "type"; value = "options"; }
								{ name = "query"; value = "{searchTerms}"; }
							];
						}];

						icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						definedAliases = [ "@no" ];
					};

					"Home-Manager Options" = {
						urls = [{
							# template = "https://mipmip.github.io/home-manager-option-search";
							# home-manager option search was moved to:
							template = "https://home-manager-options.extranix.com";
							params = [
								{ name = "query"; value = "{searchTerms}"; }
							];
						}];

						icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						definedAliases = [ "@hm" ];
					};
				};
				search.force = true;

# Settings are stored in ~/.mozilla/firefox/profile_name/prefs.js
# To find the name of a setting, wither use `diff old_settings new_settings`
# Or check which value changes in about:config when setting it in about:preferences
				settings = {
					"browser.startup.page" = "3"; # Restore pages on startup
					"media.hardware-video-decoding.force-enabled" = true;
					"layers.acceleration.force-enabled" = true;
				};

				# All available extensions:
				# https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json?ref_type=heads
				extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
					ublock-origin
					sponsorblock
					darkreader
					youtube-shorts-block
					enhanced-h264ify
				];
			};
		};
	};
}
