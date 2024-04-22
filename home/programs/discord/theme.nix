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
    .embedWrapper__47b23, embedFull__14919, embed_cc6dae {
      background-color: var(--base01) !important;
      border-radius: 6px !important;
    }

    /* Folder backgrounds */
    .expandedFolderBackground_b1385f {
      background-color: var(--base01) !important;
    }

    /* Input placeholder */
    .placeholder_dec8c7 {
      display: none !important;
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
    .scroller_e412fe {
      scrollbar-width: none !important;
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
      padding-right: 10px !important;
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
    .listItem__48528 > .listItemWrapper__3d465 > .wrapper__9916c > svg > foreignObject > div[aria-label="Explore Discoverable Servers"] {
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
