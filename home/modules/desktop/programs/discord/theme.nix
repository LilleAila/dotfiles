{config, ...}:
with config.colorScheme.palette;
with config.settings.fonts;
/*
css
*/
  ''
    /**
    * @name ${config.colorScheme.slug}
    * @author LilleAila
    * @version 1.0.0
    * @description Base16 color scheme generated from https://github.com/Misterio77/nix-colors
    **/

    /*@import url(https://mwittrien.github.io/BetterDiscordAddons/Themes/EmojiReplace/base/Apple.css);*/
    @import url(https://mwittrien.github.io/BetterDiscordAddons/Themes/SettingsModal/SettingsModal.css);

    /* Settings modal */
    :root {
      --settingswidth: 960;
      --settingsheight: 80;
      --settingsbackground: transparent;
    }

    /* My theme */
    :root {
      --base00: #${base00}; /* Black */
      --base01: #${base01}; /* Bright Black */
      --base02: #${base02}; /* Grey */
      --base03: #${base03}; /* Brighter Grey */
      --base04: #${base04}; /* Bright Grey */
      --base05: #${base05}; /* White */
      --base06: #${base06}; /* Brighter White */
      --base07: #${base07}; /* Bright White */
      --base08: #${base08}; /* Red */
      --base09: #${base09}; /* Orange */
      --base0A: #${base0A}; /* Yellow */
      --base0B: #${base0B}; /* Green */
      --base0C: #${base0C}; /* Cyan */
      --base0D: #${base0D}; /* Blue */
      --base0E: #${base0E}; /* Purple */
      --base0F: #${base0F}; /* Magenta */

      --primary-630: var(--base00); /* Autocomplete background */
      --primary-660: var(--base00); /* Search input background */
    }

    .theme-light, .theme-dark {
      --search-popout-option-fade: none; /* Disable fade for search popout */
      --bg-overlay-2: var(--base00); /* These 2 are needed for proper threads coloring */
      --home-background: var(--base00);
      --background-primary: var(--base00);
      --background-secondary: var(--base00); /* --base01 */
      --background-secondary-alt: var(--base00); /* --base01 */
      --channeltextarea-background: var(--base01);
      --background-tertiary: var(--base00);
      --background-accent: var(--base0E);
      --background-floating: var(--base01);
      --background-modifier-selected: var(--base00);
      --text-normal: var(--base05);
      --text-secondary: var(--base00);
      --text-muted: var(--base03);
      --text-link: var(--base0C);
      --interactive-normal: var(--base05);
      --interactive-hover: var(--base0C);
      --interactive-active: var(--base0A);
      --interactive-muted: var(--base03);
      --header-primary: var(--base0B); /* --base06 */
      --header-secondary: var(--base04); /* --base03 */
      --scrollbar-thin-track: transparent;
      --scrollbar-auto-track: transparent;

      --font-code ${monospace.name} !important;
      --font-display ${serif.name} !important;
      --font-headline ${serif.name} !important;
      --font-primary ${sansSerif.name} !important;
    }

    /* Stop thread icon from clipping into top bar */
    .container_cd7d9c {
      padding-top: 16px;
    }

    /* Fade out effect in DM channel scroller */
    .privateChannels__9b518::after {
      content: "";
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      z-index: 1000;
      background: linear-gradient(to bottom, transparent 85%, var(--base00));
      pointer-events: none;
    }

    /* Fix padding */
    .list__5ced9.auto_a3c0bd.scrollerBase_f742b2 {
      padding-top: 24px;
    }

    /* Missing padding in message input */
    .inner__9fd0b {
      padding-right: 12px; /* 16 - 4px margin of emoji button */
    }

    /* Right sidebar */
    .profilePanel_e2cafe {
      width: 220px;
    }

    .profileMutuals_ba77b9 {
      display: none;
    }

    .membersWrap__5ca6b {
      min-width: 180px;
      width: 180px;
      padding-top: 48px; /* Account for floating top-bar */
    }

    .members__573eb {
      width: 100%;
    }

    .name_c3d448, .username__4a6f7, .activityText__31c22 {
      text-overflow: clip;
    }

    /* Left sidebar */
    .nameTag__77ab2 {
      display: none;
    }

    .avatar_f8541f {
      border-radius: 6px;
    }
    .avatar_f8541f:hover {
      background-color: var(--base01);
    }

    .avatarWrapper__500a6 {
      min-width: 0;
      margin: 0;
    }

    .sidebar_e031be { /* The sidebar itself */
      width: 48px;
      margin-right: 8px;
    }

    .sidebar_e031be:has(.container__7e23c) { /* Server sidebars are wider */
      width: 180px !important;
    }

    .sidebar_e031be:has(.container__7e23c) .container_debb33 {
      flex-direction: row !important;
      height: 32px !important;
      padding-bottom: 8px;
      justify-content: center;
    }


    .sidebar_e031be:has(.container__7e23c) .container_debb33 .flex_f18b02 {
      flex-direction: row !important;
    }

    .avatarWithText__3fb83 {
      padding-right: 0;
      padding-left: 4px;
    }

    .searchBar__621ec {
      display: none;
    }

    .scroller__89969 {
      scrollbar-width: none !important;
    }

    .subtext__798a4 {
      display: none;
    }

    .overflow__993fa, .activityText__56d3b, .headerText__88997 {
      text-overflow: clip;
    }

    .closeButton__116c3, div[aria-label="Leave Group"] {
      display: none !important;
    }

    .interactiveSelected__689f0 {
      background-color: var(--base01);
    }

    .container_debb33 {
      flex-direction: column-reverse;
      height: 136px;
      justify-content: start;
      padding: 0;
      margin-left: 0;
    }

    .container_debb33 .flex_f18b02 {
      flex-direction: column;
    }

    .channel__0aef5.container__3792d {
      margin-left: 0;
    }

    .nameAndDecorators_c896d6 {
      display: none;
    }

    .privateChannelsHeaderContainer_b22dc9 .headerText__88997 {
      display: none;
    }

    .privateChannelRecipientsInviteButtonIcon__459c2.iconWrapper_de6cd1 {
      background-color: var(--base01);
      padding: 6px;
      border-radius: 100%;
      transition: border-radius 0.2s ease-out;
    }

    .privateChannelRecipientsInviteButtonIcon__459c2.iconWrapper_de6cd1:hover {
      border-radius: 6px;
    }

    .privateChannelsHeaderContainer_b22dc9 {
      padding: 0;
      height: 28px;
      margin-bottom: 8px;
      width: 100%;
      justify-content: center;
    }

    .layout__59abc {
      padding: 0;
      width: 100%;
    }

    .avatar__7bd22 {
      margin: 0;
      width: 100%;
    }

    .linkButton__9da2c {
      padding-right: 0;
    }

    /* Top bar transparency */
    .subtitleContainer_f50402 {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
    }

    .subtitleContainer_f50402 .title_d4ba1a {
      background-color: #${base00}44;
      backdrop-filter: blur(3px);
    }

    .children_cde9af:after {
      display: none;
    }

    .newMessagesBar__8b272 {
      top: 48px;
    }

    /* Remove profile decorations */
    [class^="profileEffects"],
    [class^="avatarDecoration"] {
      display: none;
    }

    /* Replying to */
    .replying__38514 {
      background-color: #${base0D}44 !important;
    }
    .replying__38514:hover {
      background-color: #${base0D}33 !important;
    }
    .replying__38514::before {
      background-color: var(--base0D) !important;
    }

    /* Mentions */
    .mentioned_fa6fd2:not(.replying__38514) {
      background-color: #${base0E}44 !important;
    }
    .mentioned_fa6fd2:hover:not(.replying__38514) {
      background-color: #${base0E}33 !important;
    }
    .mentioned_fa6fd2:not(.replying__38514)::before {
      background-color: var(--base0E) !important;
    }

    .mention, .channelMention {
      background-color: #${base0C}77;
      color: var(--base07);
      padding: 0 3px;
      border-radius: 4px;
    }
    .mention:hover, .channelMention:hover {
      background-color: #${base0C}55;
      color: var(--base06);
    }

    /* Message sent time */
    .timestamp_c79dd2.timestampInline__430cf {
      color: var(--base04) !important;
    }

    /* Username color */
    .username__0b0e7 {
      color: var(--base0D) !important;
    }

    /* Code blocks */
    code {
      font-family: ${monospace.name} !important;
      background-color: var(--base01) !important;
      border-radius: 6px !important;
    }

    code.inline {
      padding: 2px !important;
    }

    /* "Active Now" sidebar in friends menu */
    .nowPlayingColumn_b025fe {
      display: none !important;
    }

    /* Folder backgrounds */
    .expandedFolderBackground_b1385f {
      background-color: var(--base01) !important;
    }

    /* Disable orange outline that sometimes shows up on server list */
    .tree__7a511 {
      border: none !important;
      outline: none !important;
    }

    /* Disable background color of profile banners */
    .banner__6d414, .panelBanner__7d7e2, .bannerPremium__69560 {
      background-color: transparent !important;
      background-image: none !important;
    }

    /* Hide scrollbar */
    * {
      scrollbar-width: none;
    }
    .scroller_e412fe, .scrollableContainer_ff917f {
      scrollbar-width: none !important;
    }

    /* Top bar bottom border */
    .searchBar__621ec, .header__77c95, .content__01e65:before {
      box-shadow: none !important;
    }

    /* Name titlebar */
    .title_d4ba1a {
      padding: 0 !important;
    }

    /* Padding on right side of message input */
    .scrollableContainer_ff917f {
      padding: 0 !important;
    }

    /* Hide some unneeded buttons */
    .listItem__48528:has(.circleIconButton__05cf2[aria-label="Explore Discoverable Servers"]),
    .pill__6b31b,
    [aria-label="Start Video Call"],
    [aria-label="Inbox"],
    a[href="https://support.discord.com"],
    .guildSeparator__75928,
    .divider_bdb894, .akaBadge__27cd4, .nicknames__12efb,
    a[data-list-item-id="private-channels-uid_18___nitro"],
    a[data-list-item-id="private-channels-uid_18___shop"],
    a[href="/shop"],
    a[href="/store"],
    .form_d8a4a1::after,
    button[aria-label="Send a gift"],
    button[aria-label="Open GIF picker"],
    button[aria-label="Open sticker picker"],
    .channelTextArea-1FufC0 > .container-1ZA19X
    {
      display: none !important;
    }
  ''
