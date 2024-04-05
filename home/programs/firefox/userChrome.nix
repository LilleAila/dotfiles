{colorScheme, ...}: let
  c = colorScheme;
in
  /*
  css
  */
  ''
    /* URL bar popup */
    :root {
      --urlbarView-highlight-background: #${c.base00} !important;
      --urlbarView-highlight-color: #${c.base0B} !important;
      --urlbarView-hover-background: #${c.base01} !important;
      --urlbarView-separator-color: #${c.base00} !important;
      --toolbar-field-color: #${c.base07} !important;
    }

    /* Titlebar(s) */
    #titlebar,
    #PersonalToolbar,
    #nav-bar,
    #tabbrowser-tabs,
    #navigator-toolbox,
    #urlbar-background {
      background-color: #${c.base00} !important;
      box-shadow: none !important;
      padding: 0 !important;
      border: 0 !important;
      margin: 0 !important;
    }

    /* URL input field */
    #urlbar-input-container {
      background-color: #${c.base01} !important;
    }

    /* Some buttons */
    #unified-extensions-button,
    #permissions-granted-icon,
    #PanelUI-button,
    #blocked-permissions-container {
      color: #${c.base07} !important;
    }

    #star-button {
      fill: #${c.base0A} !important;
    }

    /* Hide search bar placeholder */
    #urlbar-input::placeholder {
        color: transparent !important;
    }

    /* Firefox menu (top-right hamburger) */
    #appMenu-popup .PanelUI-subView,
    #unified-extensions-panel .panel-header,
    #unified-extensions-panel .panel-subview-body,
    #unified-extensions-panel {
      background-color: #${c.base00} !important;
      color: #${c.base07} !important;
    }

    /* Context menus (right-click) */
    .menupopup-arrowscrollbox {
      background-color: #${c.base00} !important;
      border: 1px solid #${c.base02} !important;
      min-width: 200px !important;
    }

    /*#contentAreaContextMenu menuseparator {
      color: none !important;
      background-color: #${c.base05} !important;
      margin: 0.3em 0 !important;
      padding: 0 !important;
      height: 1px !important;
    }*/

    #contentAreaContextMenu menuseparator {
      display: none !important;
    }

    #contentAreaContextMenu menuitem {
      color: #${c.base07} !important;
      margin: 0.1em 0.1em !important;
      padding: 0.4em 0 !important;
    }

    #contentAreaContextMenu menuitem:hover {
      background-color: #${c.base01} !important;
    }

    /* Remove unnecessary context menu items */
    #context-inspect-a11y,
    #context-viewsource,
    #context-take-screenshot,
    #context-selectall,
    #context-openlink,
    #context-openlinkprivate,
    #context-savelink,
    #context-print-selection,
    #context-viewpartialsource-selection,
    #context-stripOnShareLink,
    #context-searchselect,
    #context-sendimage {
      display: none !important;
    }

    /* Make tabs more compact */
    .tabbrowser-tab {
      height: 2em !important;
      min-height: 0 !important;
      align-items: center !important;
      font-size: 0.9em !important;
      padding: 0 !important;
      margin: 0 !important;
    }
    .tabbrowser-tab * {
      margin: 0 !important;
      border-radius: 0 !important;
    }
    .tab-icon-image {
      height: auto !important;
      width: 1.1em !important;
      margin-right: 4px !important;
    }

    /* Disable the search bar (show on ctrl + L) */
    /*
    #nav-bar {
      opacity: 0 !important;
      min-height: 2.5em !important;
      height: 2.5em !important;
      margin: 0 0 -2.5em !important;
      z-index: -1000 !important;
    }
    #nav-bar:focus-within {
      z-index: 1000 !important;
      opacity: 1 !important;
    }
    */

    /* Hide some UI elements */
    #firefox-view-button,
    #tabs-newtab-button,
    #back-button,
    #forward-button,
    #reload-button,
    #stop-button,
    #save-to-pocket-button,
    #customizableui-special-spring1,
    #customizableui-special-spring2,
    #new-tab-button,
    #alltabs-button,
    .titlebar-spacer,
    .titlebar-buttonbox-container,
    #identity-box[pageproxystate=invalid] > .identity-box-button,
    .searchbar-search-button,
    #tracking-protection-icon-container,
    #urlbar .search-one-offs,
    .tab-close-button
    {
      display: none !important;
    }
  ''
