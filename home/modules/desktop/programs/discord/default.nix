{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
in
{
  options.settings.discord = {
    vesktop.enable = lib.mkEnableOption "vesktop";
    dissent.enable = lib.mkEnableOption "dissent";
    vesktop.settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.settings.discord.dissent.enable) { home.packages = with pkgs; [ dissent ]; })
    (lib.mkIf (config.settings.discord.vesktop.enable) {
      home.packages = with pkgs; [ vesktop ];

      settings.persist.home.cache = [ ".config/vesktop" ];

      home.file.".config/vesktop/settings.json".text = builtins.toJSON {
        splashColor = "#${config.colorScheme.palette.base05}";
        splashBackground = "#${config.colorScheme.palette.base01}";
        customTitleBar = false;
        staticTitle = true;
        splashTheming = true;
        tray = false;
        minimizeToTray = false;
        disableMinSize = true;
        appBadge = false;
        checkUpdates = false;
        arRPC = true;
      };

      home.file.".config/vesktop/settings/settings.json".source = jsonFormat.generate "vesktop-settings" config.settings.discord.vesktop.settings;

      home.file.".config/vesktop/themes/base16.theme.css".source = pkgs.writeText "base16.theme.css" (
        import ./theme.nix { inherit config; }
      );

      settings.discord.vesktop.settings = lib.mkDefault {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;
        disableMinSize = true;
        enabledThemes = [ "base16.theme.css" ];
        plugins = {
          AlwaysTrust.enabled = true;
          AnonymiseFileNames.enabled = true;
          BetterUploadButton.enabled = true;
          CallTimer.enabled = true;
          ClearURLS.enabled = true;
          CopyUserURLS.enabled = true;
          CrashHandler.enabled = true;
          # CtrlEnterSend.enabled = true;
          DisableCallIdle.enabled = true;
          EmoteCloner.enabled = true;
          FakeNitro.enabled = true;
          FavoriteGifSearch.enabled = true;
          FixCodeblockGap.enabled = true;
          FixSpotifyEmbeds.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          GifPaste.enabled = true;
          ImageZoom.enabled = true;
          # InvisibleChat = {
          #   enabled = true;
          #   savedPasswords = "password, Password";
          # };
          KeepCurrentChannel.enabled = true;
          LoadingQuotes.enabled = true;
          MessageClickActions.enabled = true;
          MessageLinkEmbeds.enabled = true;
          MessageLatency.enabled = true;
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          MessageTags.enabled = true;
          MoreCommands.enabled = true;
          MoreKaomoji.enabled = true;
          MutualGroupDMs.enabled = true;
          NewGuildSettings.enabled = true;
          NoF1.enabled = true;
          NoMosaic.enabled = true;
          NoPendingCount.enabled = true;
          NoProfileThemes.enabled = true;
          NormalizeMessageLinks.enabled = true;
          NoUnblockToJump.enabled = true;
          NSFWGateBypass.enabled = true;
          PermissionsViewer.enabled = true;
          petpet.enabled = true;
          PictureInPicture.enabled = true;
          PreviewMessage.enabled = true;
          QuickMention.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          RelationshipNotifier.enabled = true;
          RevealAllSpoilers.enabled = true;
          ReverseImageSearch.enabled = true;
          ReviewDB.enabled = true;
          SearchReply.enabled = true;
          SendTimestamps.enabled = true;
          ServerInfo.enabled = true;
          ShikhiCodeblocks.enabled = true;
          TypingIndicator.enabled = true;
          TypingTweaks.enabled = true;
          Unindent.enabled = true;
          UnlockedAvatarZoom.enabled = true;
          UrbanDictionary.enabled = true;
          UserVoiceShow.enabled = true;
          ValidUser.enabled = true;
          VencordToolbox.enabled = true;
          VoiceChatDoubleClick.enabled = true;
          VoiceMessages.enabled = true;
          Wikisearch.enabled = true;

          NoTrack.enabled = true;
          Settings.enabled = true;
          SupportHelper.enabled = true;
          WebContextMenus.enabled = true;
        };
      };
    })

    (lib.mkIf (config.settings.wm.hyprland.enable) {
      wayland.windowManager.hyprland.settings = {
        "$discord" = "vesktop";
        bind = [
          # TODO: Make this a general script where "vesktop" is replaced by an argument
          "$mainMod, D, exec, ${
            pkgs.writeShellScriptBin "toggle_discord"
              # bash
              ''
                #!/usr/bin/env bash

                if [[ $(pgrep -f vesktop | wc -l) -ne 0 ]]; then
                	hyprctl dispatch togglespecialworkspace discord
                else
                	vesktop &
                fi
              ''
          }/bin/toggle_discord"
          "$mainMod SHIFT, D, movetoworkspace, special:discord"
        ];
        windowrulev2 = [
          "float,class:($discord)"
          "workspace special:discord silent,class:($discord)"
        ];
      };
    })
  ];
}
