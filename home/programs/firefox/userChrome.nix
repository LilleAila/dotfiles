{colorScheme, ...}: let
  c = colorScheme;
in
  /*
  css
  */
  ''
    #titlebar, #PersonalToolbar, #nav-bar, #tabbrowser-tabs, #navigator-toolbox {
      background-color: #${c.base00} !important;
      box-shadow: none !important;
      padding: 0 !important;
      border: 0 !important;
      margin: 0 !important;
    }

    #urlbar-input-container {
      background-color: #${c.base01} !important;
    }

    #firefox-view-button,
    #tabs-newtab-button,
    #back-button,
    #forward-button,
    #reload-button,
    #save-to-pocket-button,
    #customizableui-special-spring1,
    #new-tab-button,
    #alltabs-button,
    .titlebar-spacer,
    .titlebar-buttonbox-container,
    {
      display: none !important;
    }

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
  ''
