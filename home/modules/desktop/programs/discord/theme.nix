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
      padding-top: 24px; /* Account for floating top-bar */
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
      scrollbar-width: none;
    }

    .subtext__798a4 {
      display: none;
    }

    .overflow__993fa, .activityText__56d3b, .headerText__88997 {
      text-overflow: clip;
    }

    /*button[aria-label="Mute"], button[aria-label="Deafen"] {*/
    /*  display: none;*/
    /*}*/

    .closeButton__116c3, div[aria-label="Leave Group"] {
      display: none !important;
    }

    .container_debb33 {
      flex-direction: column;
      height: 128px;
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
    [class^="profileEffects"] {
      display: none;
    }

    [class^="avatarDecoration"] {
      display: none;
    }

    /* Mentions */
    .mentioned_fa6fd2 {
      background-color: #${base0E}44 !important;
    }
    .mentioned_fa6fd2:hover {
      background-color: #${base0E}33 !important;
    }
    .mentioned_fa6fd2::before {
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

    /* Message embeds */
    /*
    .embedWrapper__47b23, embedFull__14919, embed_cc6dae {
      background-color: var(--base01) !important;
      border-radius: 6px !important;
    }
    */

    /* Left sidebar (disabled because settings and other buttons disappear) */
    /*
    .sidebar_e031be {
      width: 150px !important;
    }
    */

    /* "Active Now" sidebar in friends menu */
    .nowPlayingColumn_b025fe {
      display: none !important;
    }

    /* Folder backgrounds */
    .expandedFolderBackground_b1385f {
      background-color: var(--base01) !important;
    }

    /* Input placeholder */
    /*.placeholder_dec8c7 {*/
    /*  display: none !important;*/
    /*}*/

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

    /* Hide unneded buttons in message input */
    button[aria-label="Send a gift"],
    button[aria-label="Open GIF picker"],
    button[aria-label="Open sticker picker"],
    .channelTextArea-1FufC0 > .container-1ZA19X {
        display: none !important;
    }

    /* Padding on right side of message input */
    .scrollableContainer_ff917f {
      padding-right: -5px !important;
    }

    /* Hide weird square in top-right of message input */
    .form_d8a4a1::after {
      display: none !important;
    }

    /* Hide shop and nitro buttons */
    a[data-list-item-id="private-channels-uid_18___nitro"],
    a[data-list-item-id="private-channels-uid_18___shop"],
    a[href="/shop"],
    a[href="/store"] {
      display: none !important;
    }

    /* Hide nicknames text */
    .divider_bdb894, .akaBadge__27cd4, .nicknames__12efb {
      display: none !important;
    }

    /* Hide that one separator on top of server list */
    .guildSeparator__75928 {
      display: none !important;
    }

    /* Hide top-right help button */
    a[href="https://support.discord.com"] {
      display: none !important;
    }

    /* Hide explore button (hover tooltip is still there..) */
    .listItem__48528 > .listItemWrapper__3d465 > .wrapper__9916c > svg > foreignObject > div[arialabel="Explore Discoverable Servers"] {
      display: none !important;
    }

    /* Hide unread indicator */
    .pill__6b31b {
      display: none !important;
    }

    /* Hide video call button */
    [aria-label="Start Video Call"] {
      display: none !important;
    }

    [aria-label="Inbox"] {
      display: none !important;
    }
  ''
