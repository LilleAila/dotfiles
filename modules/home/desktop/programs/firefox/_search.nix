{ pkgs, ... }:
{
  default = "google"; # It does have bad privacy but also slightly better results most of the time

  engines = {
    "Searx" = {
      urls = [
        {
          # NOTE: only works when searx is enabled and running locally
          template = "http://localhost:6969";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = [ "@sx" ];
    };

    "Ordbokene" = {
      urls = [ { template = "https://ordbokene.no/nno/bm,nn/{searchTerms}"; } ];
      definedAliases = [ "@oo" ];
    };

    "NixOS Wiki" = {
      urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
      icon = "https://wiki.nixos.org/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # Every day
      definedAliases = [ "@nw" ];
    };

    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };

    "Nix Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "type";
              value = "options";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@no" ];
    };

    "Home-Manager Options" = {
      urls = [
        {
          # template = "https://mipmip.github.io/home-manager-option-search";
          # home-manager option search was moved to:
          template = "https://home-manager-options.extranix.com";
          params = [
            {
              name = "release";
              value = "master";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@hm" ];
    };
  };
  force = true;
}
