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
                zotero-connector
                bitwarden
                violentmonkey
              ];
              settings = import ./settings.nix { inherit config; };
              userChrome = import ./userChrome.nix { colorScheme = config.colorScheme.palette; };
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
                inherit search settings;
                extensions.packages = extensions;
                userChrome = userChrome + (with config.colorScheme.palette; colorTab base0D base00);
              };

              school = {
                id = 1;
                inherit search settings;
                extensions.packages = extensions;
                userChrome = userChrome + (with config.colorScheme.palette; colorTab base0B base00);
              };
            };
        };
      }
    ]
  );
}
