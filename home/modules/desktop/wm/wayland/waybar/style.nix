config:
let
  c = config.colorScheme.palette;
  f = config.settings.fonts;
in
# scss
''
  * {
    font-family: ${f.nerd.name};
    font-size: ${toString f.size}pt;
    border-radius: 0;
    transition: none;
    color: #${c.base06};
  }
  .modules-left {
    margin-left: 20px;
  }
  .modules-right {
    margin-right: 20px;
  }
  window#waybar {
    background-color: #${c.base00};
  }

  #workspaces button {
    padding: 0;
    border-top: 1px solid transparent;

    &.focused {
      border-top-color: #${c.base05};
      background-color: rgba(#${c.base01}, 0.8);
    }

    &:hover {
      background-color: rgba(#${c.base01}, 0.3);
    };

    &.urgent {
      background-color: rgba(#${c.base08}, 0.8);
    }
  }

  #mode {
    background-color: rgba(#${c.base0D}, 0.6);
    color: #${c.base07};
    padding: 0 8px;
  }

  #battery {
    padding: 0 8px;

    &.charging {
      color: #${c.base0B};
    }

    &:not(.charging) {
      &.warning {
        background-color: #${c.base09};
      }

      &.critical {
        background-color: #${c.base08};
        color: #${c.base02};
      }
    }
  }
  window#waybar.battery-warning {
    background-color: mix(#${c.base00}, #${c.base09}, 80%);
  }
  window#waybar.battery-critical {
    background-color: mix(#${c.base00}, #${c.base08}, 80%);
  }

  #tray {
    padding-left: 10px;
  }
  #tray menu {
    background-color: #${c.base00};
    border: 1px solid #${c.base05};
  }
''
