{
  inputs,
  pkgs,
  lib,
  config,
  isNixOS ? false,
  ...
}:
{
  options.settings.browser.firefox = {
    enable = lib.mkEnableOption "firefox";
    newtab_image = lib.mkOption { type = lib.types.path; };
  };

  config = lib.mkIf config.settings.browser.firefox.enable (
    lib.mkMerge [
      (lib.mkIf isNixOS {
        # The package is set to null here because firefox is configured in system, see `nixosModules/firefox.nix`
        programs.firefox.package = null;
      })
      (lib.mkIf config.settings.wm.sway.enable {
        wayland.windowManager.sway.config.window.commands = [
          {
            criteria.app_id = "firefox";
            command = "move container to workspace number 2";
          }
          {
            criteria.app_id = "firefox-yt";
            command = "move container to workspace number 3";
          }
          {
            criteria.app_id = "firefox-school";
            command = "move container to workspace number 4";
          }
        ];

        settings.wlr-which-key.menus.firefox =
          let
            url = desc: url: {
              inherit desc;
              cmd = "firefox -P main --new-tab \"${url}\"";
            };
          in
          {
            p = {
              desc = " Profiles";
              submenu = {
                b.desc = " Main";
                b.cmd = "firefox -P main";
                y.desc = " YouTube";
                y.cmd = "firefox -P yt --name=firefox-yt";
                s.desc = " School";
                s.cmd = "firefox -P school --name=firefox-school";
              };
            };
            g = {
              desc = "󰊤 GitHub";
              submenu = {
                g = url "󰊤 GitHub" "https://github.com";
                l = url " LilleAila dots" "https://github.com/LilleAila/dotfiles";
                i = url " IldenH dots" "https://github.com/IldenH/dotfiles";
                n = url "󱄅 Nixpkgs" "https://github.com/NixOS/nixpkgs";
                h = url " Home-manager" "https://github.com/nix-community/home-manager";
              };
            };
            d = {
              desc = "󰈙 Documentation";
              submenu = {
                a = url "󱍕 AGS" "https://aylur.github.io/ags-docs";
                v = url " Nixvim" "https://nix-community.github.io/nixvim";
                n = url "󱄅 Nixpkgs" "https://ryantm.github.io/nixpkgs/";
                s = url " Stylix" "https://github.com/danth/stylix";
              };
            };
            a = url " Astro" "localhost:4321";
            s = url " Synthing" "localhost:8384";
            c = url "󰭹 ChatGPT" "https://chatgpt.com";
            t = url " Temp mail" "https://temp-mail.org";
            n = url " Nerd fonts" "https://www.nerdfonts.com/cheat-sheet";
          };
      })
      {
        settings.persist.home.directories = [
          ".mozilla"
          ".cache/mozilla"
        ];
        programs.firefox = {
          enable = true;
          package = lib.mkDefault pkgs.firefox;
          profiles =
            let
              search = import ./search.nix { inherit pkgs; };
              extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
                ublock-origin
                sponsorblock
                darkreader
                youtube-shorts-block
                enhanced-h264ify
                clearurls
                # tridactyl
              ];
              settings = import ./settings.nix { inherit config; };
              userChrome = import ./userChrome.nix { colorScheme = config.colorScheme.palette; };
              userContent = import ./userContent.nix { inherit config pkgs; };
              colorTab = bg: fg: ''
                .tab-background[selected] {
                  background-color: #${bg} !important;
                  background-image: none !important;
                }
                .tab-content[selected] {
                  color: #${fg} !important;
                }
              '';
            in
            {
              main = {
                isDefault = true;
                id = 0;
                inherit search extensions userContent;
                settings = settings // {
                  "browser.startup.homepage" = "https://start.duckduckgo.com";
                };
                userChrome = userChrome + (with config.colorScheme.palette; colorTab base0D base00);
                bookmarks = import ./bookmarks/main.nix;
              };

              school = {
                id = 1;
                inherit search extensions userContent;
                settings = settings // {
                  "browser.startup.homepage" = "https://classroom.google.com";
                };
                userChrome = userChrome + (with config.colorScheme.palette; colorTab base0B base00);
                bookmarks = import ./bookmarks/school.nix;
              };

              yt = {
                id = 3;
                inherit search extensions userContent;
                settings = settings // {
                  "browser.startup.homepage" = "https://youtube.com";
                };
                userChrome = userChrome + (with config.colorScheme.palette; colorTab base08 base00);
                bookmarks = import ./bookmarks/yt.nix;
              };
            };
        };
      }
    ]
  );
}
