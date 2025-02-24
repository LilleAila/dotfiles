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
