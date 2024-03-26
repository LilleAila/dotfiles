{ config, pkgs, inputs, lib, stdenv, ... }:

{
	options.settings.browser.firefox.enable = lib.mkEnableOption "firefox";

	config = let
		search = {
			default = "DuckDuckGo";
			engines = {
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
			force = true;
		};

		# Settings are stored in ~/.mozilla/firefox/profile_name/prefs.js
		# To find the name of a setting, either use `diff old_settings new_settings`
		# Or check which value changes in about:config when setting it in about:preferences
		settingsWithHomepage = homepage: {
			"browser.startup.page" = 3; # Restore pages on startup
			"media.hardware-video-decoding.force-enabled" = true;
			"layers.acceleration.force-enabled" = true;

			"browser.toolbars.bookmarks.visibility" = "always";
			"browser.disableResetPrompt" = true;
			"browser.download.panel.shown" = true;
			"browser.download.useDownloadDir" = false;
			"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
			"dom.security.https_only_mode" = true;
			"identity.fxaccounts.enabled" = false;
			"privacy.trackingprotection.enabled" = true;
			"signon.rememberSignons" = false;
			"browser.shell.checkDefaultBrowser" = false;
			"browser.shell.defaultBrowserCheckCount" = 1;
			"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
			"browser.startup.homepage_override.mstone" = "ignore";

			"browser.tabs.firefox-view" = false;
			"browser.tabs.tabmanager.enabled" = false;

			"browser.translations.neverTranslateLanguages" = "nb,nn,fr,en";
			# "browser.startup.homepage" = "https://start.duckduckgo.com";
			"browser.startup.homepage" = homepage;
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

		colorTab = bg: fg: ''
		.tab-background[selected] {
			background-color: #${bg} !important;
			background-image: none !important;
		}
		.tab-content[selected] {
			color: #${fg} !important;
		}
		'';
	in lib.mkIf (config.settings.browser.firefox.enable) {
		programs.firefox = {
			enable = true;
			profiles.main = {
				settings = settingsWithHomepage "https://start.duckduckgo.com";
				inherit search;
				inherit extensions;
				isDefault = true;
				id = 0;

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

				userChrome = with config.colorScheme.palette; colorTab base0D base00;
			};

			profiles.school = {
				settings = settingsWithHomepage "https://classroom.google.com";
				inherit search;
				inherit extensions;
				id = 1;
				bookmarks = [{
					name = "Toolbar";
					toolbar = true;
					bookmarks = [
						{ name = "Classroom"; url = "https://classroom.google.com"; }
						{ name = "Docs"; url = "https://docs.google.com"; }
						{ name = "Slides"; url = "https://slides.google.com"; }
						{ name = "Sheets"; url = "https://sheets.google.com"; }
						{ name = "Drive"; url = "https://drive.google.com"; }
						{
							name = "Documents";
							bookmarks = [
								{ name = "English"; url = "https://docs.google.com/document/d/1xj9lDLwrGXKkkqr5mEVQLZdQxfKjBSPiBl9a9aHrhNQ/edit"; }
								{ name = "Nynorsk"; url = "https://docs.google.com/document/d/1hF0peeWeIx4bNYaykgMdfm3YrZyJsipjhb_6KqQueeg/edit"; }
								{ name = "Norsk"; url = "https://docs.google.com/document/d/1bKgBIAGnONUg9TsEbsb8hGr2u6LgrHCrLBAUk1Ivv-s/edit"; }
								{ name = "KRLE"; url = "https://docs.google.com/document/d/1wWP4jjaiFDXDRO1LBMBmbOSPSd0ZXMbhcNb9vgMWK44/edit"; }
								{ name = "Samfunnsfag"; url = "https://docs.google.com/document/d/1AMq0_-sWujxhk5OspIRB4MrFLWIe2Izvn1I_e1T9rhg/edit"; }
								{ name = "Fransk"; url = "https://docs.google.com/document/d/1ttxzRWYRL_4W4kixq78qgt09NqbmVisZcHJ6_FCb99Q/edit"; }
								{ name = "Musikk"; url = "https://docs.google.com/document/d/10DauaVT-wLxNg3A8VgM5a4zAvoLF7vCqhhVLZeEIEe8/edit"; }
								{ name = "Matte"; url = "https://docs.google.com/document/d/1jsF9bZ8rUd8sUd75SlvpIqlNVzKF6kBdeogEvenct0U/edit"; }
								{ name = "Matte regneark"; url = "https://docs.google.com/spreadsheets/d/19JvJXjdEXP_HnbMi89cvK6Kb8yT-gQsTk6U_P4c7k6Q/edit"; }
								{ name = "Naturfag"; url = "https://docs.google.com/document/d/1MkoYDXgKMk9SbBmSpr2izJ9iBOjOAlryh-UeayjFj0M/edit"; }
								{ name = "K&H"; url = "https://docs.google.com/document/d/1ISrUL7hzWwBrSdELAFkYC2CBjyvx_rWS9s5M53TG9AM/edit"; }
							];
						}
					];
				}];
				userChrome = with config.colorScheme.palette; colorTab base0B base00;
			};

			profiles.math = {
				settings = settingsWithHomepage "https://skole.digilaer.no";
				inherit search;
				inherit extensions;
				id = 2;
				bookmarks = [{
					name = "Toolbar";
					toolbar = true;
					bookmarks = [
						{ name = "Digilær"; url = "https://skole.digilaer.no"; }
						{ name = "GeoGebra"; url = "https://geogebra.org/classic"; }
						{ name = "Symbolab"; url = "https://symbolab.com"; }
					];
				}];
				userChrome = with config.colorScheme.palette; colorTab base0E base00;
			};

			profiles.yt = {
				settings = settingsWithHomepage "https://youtube.com";
				inherit search;
				inherit extensions;
				id = 3;
				bookmarks = [{
					name = "Toolbar";
					toolbar = true;
					bookmarks = [
						{ name = "YouTube"; url = "https://youtube.com"; }
					];
				}];
				userChrome = with config.colorScheme.palette; colorTab base08 base00;
			};
		};

		xdg.mimeApps.defaultApplications = {
			"text/html" = [ "firefox.desktop" ];
			"text/xml" = [ "firefox.desktop" ];
			"x-scheme-handler/http" = [ "firefox.desktop" ];
			"x-scheme-handler/https" = [ "firefox.desktop" ];
		};
	};
}
