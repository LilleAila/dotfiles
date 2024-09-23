{ pkgs, ... }:
{
  default = "Google"; # It does have bad privacy but also slightly better results most of the time

  engines = {
    "Searx" = {
      urls = [
        {
          template = "http://localhost:6969";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "Google".metaData.alias = "@g";

    "Ordbokene" = {
      urls = [ { template = "https://ordbokene.no/nno/bm,nn/{searchTerms}"; } ];
      definedAliases = [ "@oo" ];
    };

    "NixOS Wiki" = {
      urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
      iconUpdateURL = "https://wiki.nixos.org/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # Every day
      definedAliases = [ "@nw" ];
    };

    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages?channel=unstable";
          params = [
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
          template = "https://search.nixos.org/options?channel=unstable";
          params = [
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
