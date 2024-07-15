# https://syndishanx.github.io/Website/Update_Classes.html
# Maybe TODO later?:
# https://github.com/Elisniper/MBD/blob/main/Addons/ChatBubbles.css
{ config, lib, ... }:

with config.colorScheme.palette;
with config.settings.fonts;
# css
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
    --font-primary ${monospace.name} !important;
  }

  /* Vencord update notification */
  /* #vc-notification-container {
    display: none !important;
  } */

  /* Active channel */
  .selected_f6f816 .link_d8bfb3 {
    background-color: var(--base01) !important;
    border-radius: 12px;
  }

  .selected_f6f816 .name_d8bfb3 {
    color: var(--base0E) !important;
  }

  /* Unread message red line thing */
  .isUnread_c2654d {
    margin-bottom: 16px !important;
  }

  /* Font and spacing stuff */
  .groupStart_d5deea {
    margin-top: 2px !important;
  }

  .message_d5deea {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
    /* could also set --custom-message-spacing-vertical-container-cozy variable */
  }

  .messageContent_f9f2ca,
  .username_f9f2ca,
  .botText_a02df3,
  .timestamp_f9f2ca,
  .timestampInline_f9f2c,
  .editor_a552a6,
  .slateTextArea_e52116,
  .name_d8bfb3,
  .contents_dd4f85,
  .username_f9f2ca,
  .repliedTextContent_f9f2ca,
  .markup_f8f345 {
    /*font-size: ${toString (lib.fonts.toPx size)}px;*/
    font-size: ${toString size}pt !important;
  }

  ::-webkit-input-placeholder, body, button, input, select, textarea {
      font-family: "${monospace.name}";
  }

  /* Squircle avatars instead of square */
  .avatar_f9f2ca {
    border-radius: 8px;
  }

  /* Fix thread channel header */
  .container_c2668b {
    padding-top: 16px;
  }

  .content_eed6a8 {
    margin-top: 24px;
  }

  /* Fade out effect in DM channel scroller */
  .privateChannels_f0963d::after {
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
  .list_a6d69a.auto_eed6a8.scrollerBase_eed6a8 {
    padding-top: 24px;
  }

  /* Missing padding in message input */
  .inner_d0696b {
    padding-right: 12px; /* 16 - 4px margin of emoji button */
  }

  /* Right sidebar */
  .profilePanel_b433b4 {
    width: 220px;
  }

  .profileMutuals_b433b4 {
    display: none;
  }

  .membersWrap_cbd271 {
    min-width: 180px;
    width: 180px;
    padding-top: 48px; /* Account for floating top-bar */
  }

  .members_cbd271 {
    width: 100%;
  }

  .name_a31c43, .username_de3235, .activityText_a31c43 {
    text-overflow: clip;
  }

  /* Left sidebar */
  .nameTag_b2ca13 {
    display: none;
  }

  .avatar_b2ca13 {
    border-radius: 6px;
  }
  .avatar_b2ca13:hover {
    background-color: var(--base01);
  }

  .avatarWrapper_b2ca13 {
    min-width: 0;
    margin: 0;
  }

  .sidebar_a4d4d9 { /* The sidebar itself */
    width: 48px;
    margin-right: 8px;
  }

  .sidebar_a4d4d9:has(.container_ee69e0) { /* Server sidebars are wider */
    width: 180px !important;
  }

  .sidebar_a4d4d9:has(.container_ee69e0) .container_b2ca13 {
    flex-direction: row !important;
    height: 32px !important;
    padding-bottom: 8px;
    justify-content: center;
  }


  .sidebar_a4d4d9:has(.container_ee69e0) .container_b2ca13 .flex_bba380 {
    flex-direction: row !important;
  }

  .avatarWithText_c91bad {
    padding-right: 0;
    padding-left: 4px;
  }

  .searchBar_f0963d {
    display: none;
  }

  .scroller_c47fa9 {
    scrollbar-width: none !important;
  }

  .subtext_c91bad {
    display: none;
  }

  .overflow_c74e70, .activityText_c91bad, .headerText_c47fa9 {
    text-overflow: clip;
  }

  .closeButton_c91bad, div[aria-label="Leave Group"] {
    display: none !important;
  }

  .interactiveSelected_c91bad {
    background-color: var(--base01);
  }

  .container_b2ca13 {
    flex-direction: column-reverse;
    height: 136px;
    justify-content: start;
    padding: 0;
    margin-left: 0;
  }

  .container_b2ca13 .flex_bba380 {
    flex-direction: column;
  }

  .channel_c91bad.container_b15955 {
    margin-left: 0;
  }

  .nameAndDecorators_f9647d {
    display: none;
  }

  .privateChannelsHeaderContainer_c47fa9 .headerText_c47fa9 {
    display: none;
  }

  .privateChannelRecipientsInviteButtonIcon_c47fa9.iconWrapper_e44302 {
    background-color: var(--base01);
    padding: 6px;
    border-radius: 100%;
    transition: border-radius 0.2s ease-out;
  }

  .privateChannelRecipientsInviteButtonIcon_c47fa9.iconWrapper_e44302:hover {
    border-radius: 6px;
  }

  .privateChannelsHeaderContainer_c47fa9 {
    padding: 0;
    height: 28px;
    margin-bottom: 8px;
    width: 100%;
    justify-content: center;
  }

  .layout_f9647d {
    padding: 0;
    width: 100%;
  }

  .avatar_f9647d {
    margin: 0;
    width: 100%;
  }

  .linkButton_c91bad {
    padding-right: 0;
  }

  /* Top bar transparency */
  .subtitleContainer_a7d72e {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
  }

  .subtitleContainer_a7d72e .title_a7d72e {
    background-color: #${base00}44;
    backdrop-filter: blur(3px);
  }

  .children_e44302:after {
    display: none;
  }

  .newMessagesBar_cf58b5 {
    top: 48px;
  }

  /* Remove profile decorations */
  [class^="profileEffects"],
  [class^="avatarDecoration"] {
    display: none;
  }

  /* Replying to */
  .replying_d5deea {
    background-color: #${base0D}44 !important;
  }
  .replying_d5deea:hover {
    background-color: #${base0D}33 !important;
  }
  .replying_d5deea::before {
    background-color: var(--base0D) !important;
  }

  /* Mentions */
  .mentioned_d5deea:not(.replying_d5deea) {
    background-color: #${base0E}44 !important;
  }
  .mentioned_d5deea:hover:not(.replying_d5deea) {
    background-color: #${base0E}33 !important;
  }
  .mentioned_d5deea:not(.replying_d5deea)::before {
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
  .timestamp_ec86aa.timestampInline_ec86aa {
    color: var(--base04) !important;
  }

  /* Username color */
  .username_ec86aa {
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
  .nowPlayingColumn_c2739c {
    display: none !important;
  }

  /* Folder backgrounds */
  .expandedFolderBackground_bc7085 {
    background-color: var(--base01) !important;
  }

  /* Disable orange outline that sometimes shows up on server list */
  .tree_fea3ef {
    border: none !important;
    outline: none !important;
  }

  /* Disable background color of profile banners */
  .banner_c3e427, .panelBanner_c3e427, .bannerPremium_c3e427 {
    background-color: transparent !important;
    background-image: none !important;
  }

  /* Hide scrollbar */
  * {
    scrollbar-width: none;
  }
  .scroller_e2e187, .scrollableContainer_d0696b {
    scrollbar-width: none !important;
  }

  /* Top bar bottom border */
  .searchBar_f0963d, .header_fd6364, .content_a7d72e:before {
    box-shadow: none !important;
  }

  /* Name titlebar */
  .title_a7d72e {
    padding: 0 !important;
  }

  /* Padding on right side of message input */
  .scrollableContainer_d0696b {
    padding: 0 !important;
  }

  /* Hide some unneeded buttons */
  .listItem_c96c45:has(.circleIconButton_db6521[aria-label="Explore Discoverable Servers"]),
  .pill_a5ad63,
  [aria-label="Start Video Call"],
  [aria-label="Inbox"],
  a[href="https://support.discord.com"],
  .guildSeparator_d0c57e,
  .divider_e44302, .akaBadge__27cd4, .nicknames__12efb,
  a[data-list-item-id="private-channels-uid_18___nitro"],
  a[data-list-item-id="private-channels-uid_18___shop"],
  a[href="/shop"],
  a[href="/store"],
  .form_a7d72e::after,
  button[aria-label="Send a gift"],
  button[aria-label="Open GIF picker"],
  button[aria-label="Open sticker picker"],
  .channelTextArea_a7d72e > .container_ccd3df
  {
    display: none !important;
  }
''
