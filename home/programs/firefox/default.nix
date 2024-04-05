{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.settings.browser.firefox = {
    enable = lib.mkEnableOption "firefox";
    newtab_image = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.browser.firefox.enable) {
      programs.firefox = {
        enable = true;
        profiles = let
          search = import ./search.nix {inherit pkgs;};
          extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
            ublock-origin
            sponsorblock
            darkreader
            youtube-shorts-block
            enhanced-h264ify
            clearurls
          ];
          settings = import ./settings.nix;
          userChrome = import ./userChrome.nix {colorScheme = config.colorScheme.palette;};
          userContent = import ./userContent.nix {inherit config;};
          colorTab = bg: fg: ''
            .tab-background[selected] {
              background-color: #${bg} !important;
              background-image: none !important;
            }
            .tab-content[selected] {
              color: #${fg} !important;
            }
          '';
        in {
          main = {
            isDefault = true;
            id = 0;
            inherit search extensions userContent;
            settings =
              settings
              // {
                "browser.startup.homepage" = "https://start.duckduckgo.com";
              };
            userChrome = userChrome + (with config.colorScheme.palette; colorTab base0D base00);
            bookmarks = import ./bookmarks/main.nix;
          };

          school = {
            id = 1;
            inherit search extensions userContent;
            settings =
              settings
              // {
                "browser.startup.homepage" = "https://classroom.google.com";
              };
            userChrome = userChrome + (with config.colorScheme.palette; colorTab base0B base00);
            bookmarks = import ./bookmarks/school.nix;
          };

          math = {
            id = 2;
            inherit search extensions userContent;
            settings =
              settings
              // {
                "browser.startup.homepage" = "https://skole.digilaer.no";
              };
            userChrome = userChrome + (with config.colorScheme.palette; colorTab base0E base00);
            bookmarks = import ./bookmarks/math.nix;
          };

          yt = {
            id = 3;
            inherit search extensions userContent;
            settings =
              settings
              // {
                "browser.startup.homepage" = "https://youtube.com";
              };
            userChrome = userChrome + (with config.colorScheme.palette; colorTab base08 base00);
            bookmarks = import ./bookmarks/yt.nix;
          };
        };
      };
    })
  ];
}
