{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  home = {
    stateVersion = "24.11";
    username = "olai";
    homeDirectory = "/Users/${config.home.username}";
    shellAliases = {
      osbuild = "darwin-rebuild switch --flake ${config.home.homeDirectory}/dotfiles";
    };
    sessionVariables = {
      OBSIDIAN_REST_API_KEY = "placeholder";
    };
  };

  home.packages = with pkgs; [
    inputs.nixvim-config.packages.${pkgs.system}.default
    mas
    ffmpeg
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  programs = {
    gpg.enable = true;

    firefox = {
      enable = true;
      package = null;
      profiles = {
        main = {
          isDefault = true;
          id = 0;
          settings = {
            "extensions.autoDisableScopes" = 0; # Auto-enable extensions
          };
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
            ublock-origin
            sponsorblock
            darkreader
            youtube-shorts-block
            enhanced-h264ify
            zotero-connector
            (onepassword-password-manager.overrideAttrs { meta.license = lib.licenses.free; }) # bruh
          ];
        };
      };
    };

    # nix-darwin module is excactly the same except with "settings" instead of "userSettings". Probably doesn't matter which is used.
    aerospace = {
      enable = true;
      package = pkgs.emptyDirectory;
      userSettings = {
        start-at-login = true;
        automatically-unhide-macos-hidden-apps = true;
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        mode.main.binding = {
          alt-r = "reload-config";
          alt-o = "fullscreen";
          alt-f = "layout floating tiling";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          cmd-1 = "workspace 1";
          cmd-2 = "workspace 2";
          cmd-3 = "workspace 3";
          cmd-4 = "workspace 4";
          cmd-5 = "workspace 5";
          cmd-6 = "workspace 6";
          cmd-7 = "workspace 7";
          cmd-8 = "workspace 8";
          cmd-9 = "workspace 9";
          cmd-0 = "workspace 10";
          cmd-shift-1 = "move-node-to-workspace 1";
          cmd-shift-2 = "move-node-to-workspace 2";
          cmd-shift-3 = "move-node-to-workspace 3";
          cmd-shift-4 = "move-node-to-workspace 4";
          cmd-shift-5 = "move-node-to-workspace 5";
          cmd-shift-6 = "move-node-to-workspace 6";
          cmd-shift-7 = "move-node-to-workspace 7";
          cmd-shift-8 = "move-node-to-workspace 8";
          cmd-shift-9 = "move-node-to-workspace 9";
          cmd-shift-0 = "move-node-to-workspace 10";
        };
      };
    };

    ghostty = {
      enable = true;
      package = null;
      settings = {
        theme = config.colorScheme.slug;
        font-size = 12;
        font-family = "JetBrainsMono Nerd Font";
      };
      themes.${config.colorScheme.slug} = with config.colorScheme.palette; {
        background = base00;
        cursor-color = base06;
        cursor-text = base00;
        foreground = base06;
        selection-background = base03;
        selection-foreground = base06;
        palette = [
          "0=#${base00}"
          "1=#${base08}"
          "2=#${base0B}"
          "3=#${base0A}"
          "4=#${base0D}"
          "5=#${base0E}"
          "6=#${base0C}"
          "7=#${base03}"
          "8=#${base02}"
          "9=#${base08}"
          "10=#${base0B}"
          "11=#${base0A}"
          "12=#${base0D}"
          "13=#${base0E}"
          "14=#${base0C}"
          "15=#${base06}"
        ];
      };
    };

    git = {
      enable = true;
      userName = "LilleAila";
      userEmail = "olai.solsvik@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgSign = true;
      };
      aliases = {
        p = "push";
        c = "commit -m";
        aa = "add -A";
      };
      ignores = [
        ".direnv"
        "result"
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
    starship.enable = true;
    direnv.enable = true;
  };
}
