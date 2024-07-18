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
      (lib.mkIf config.settings.wm.hyprland.enable {
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
                m.desc = " Math";
                m.cmd = "firefox -P math";
                y.desc = " YouTube";
                y.cmd = "firefox -P yt";
                s.desc = " School";
                s.cmd = "firefox -P school";
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
                h = url " Hyprland" "https://wiki.hyprland.org";
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

        wayland.windowManager.hyprland =
          let
            c = config.colorScheme.palette;
            inactive = config.wayland.windowManager.hyprland.settings.general."col.inactive_border";
            mkShortcut = key: url: { inherit key url; };
            shortcuts = [
              (mkShortcut "L" "https://github.com/LilleAila/dotfiles/")
              (mkShortcut "I" "https://github.com/IldenH/dotfiles/")
              (mkShortcut "H" "https://wiki.hyprland.org/")
              (mkShortcut "A" "https://aylur.github.io/ags-docs/")
              (mkShortcut "G" "https://grep.app/")
              (mkShortcut "C" "https://chat.openai.com/")
              (mkShortcut "T" "https://temp-mail.org")
              (mkShortcut "N" "https://nix-community.github.io/nixvim")
              (mkShortcut "S" "http://127.0.0.1:8384/")
            ];
          in
          {
            settings.bind = [
              # Bordercolors don't work :( it reverts to default color when window is unfocused and re-focused
              "$mainMod, B, exec, [workspace 2;bordercolor rgb(${c.base0D}) ${inactive}] firefox -P main"
              "$mainMod, M, exec, [workspace 4;bordercolor rgb(${c.base0E}) ${inactive}] firefox -P math"
              "$mainMod SHIFT, B, exec, [workspace 4;bordercolor rgb(${c.base0B}) ${inactive}] firefox -P school"
              "$mainMod, Y, exec, [workspace 3;bordercolor rgb(${c.base08}) ${inactive}] firefox -P yt"
            ];
            extraConfig =
              ''
                bind = $mainMod CONTROL, B, submap, browser
                submap = browser
              ''
              + (lib.concatStringsSep "\n" (
                map (w: ''
                  bind = , ${w.key}, exec, firefox -P main --new-tab "${w.url}"
                  bind = , ${w.key}, submap, reset
                '') shortcuts
              ))
              + ''
                bind = , escape, submap, reset
                submap = reset
              '';
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

              math = {
                id = 2;
                inherit search extensions userContent;
                settings = settings // {
                  "browser.startup.homepage" = "https://skole.digilaer.no";
                };
                userChrome = userChrome + (with config.colorScheme.palette; colorTab base0E base00);
                bookmarks = import ./bookmarks/math.nix;
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
