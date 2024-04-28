{pkgs, ...}: {
  default = "DuckDuckGo";
  engines = {
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
      definedAliases = ["@np"];
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
      definedAliases = ["@no"];
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
      definedAliases = ["@hm"];
    };
  };
  force = true;
}
