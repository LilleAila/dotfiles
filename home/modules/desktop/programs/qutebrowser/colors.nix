{config, ...}: let
  c = config.colorScheme.palette;

  background = "#${c.base00}";
  secondary-background = "#${c.base01}";
  selection-background = "#${c.base02}";

  foreground = "#${c.base05}";
  inverted-foreground = "#${c.base00}";

  error = "#${c.base08}";

  info = "#${c.base0B}";
  secondary-info = "#${c.base0C}";

  warning = "#${c.base0E}";
in {
  completion = {
    category = {
      bg = background;
      fg = info;

      border = {
        bottom = background;
        top = background;
      };
    };

    even.bg = background;
    fg = foreground;

    item.selected = {
      bg = selection-background;

      border = {
        bottom = selection-background;
        top = selection-background;
      };

      fg = foreground;
    };

    match.fg = info;
    odd.bg = secondary-background;

    scrollbar = {
      bg = background;
      fg = foreground;
    };
  };

  contextmenu = {
    disabled = {
      bg = secondary-background;
      fg = inverted-foreground;
    };

    menu = {
      bg = background;
      fg = foreground;
    };

    selected = {
      bg = selection-background;
      fg = foreground;
    };
  };

  downloads = {
    bar.bg = background;

    error = {
      bg = error;
      fg = inverted-foreground;
    };

    start = {
      bg = info;
      fg = inverted-foreground;
    };

    stop = {
      bg = secondary-info;
      fg = inverted-foreground;
    };
  };

  hints = {
    bg = secondary-background;
    fg = foreground;
    match.fg = info;
  };

  keyhint = {
    bg = background;
    fg = foreground;
    suffix.fg = foreground;
  };

  messages = {
    error = {
      bg = error;
      fg = inverted-foreground;
      border = error;
    };

    info = {
      bg = info;
      fg = inverted-foreground;
      border = info;
    };

    warning = {
      bg = warning;
      fg = inverted-foreground;
      border = warning;
    };
  };

  prompts = {
    bg = background;
    border = background;
    fg = foreground;
    selected.bg = secondary-background;
  };

  statusbar = {
    caret = {
      bg = secondary-background;
      fg = foreground;

      selection = {
        bg = secondary-background;
        fg = foreground;
      };
    };

    command = {
      bg = background;
      fg = foreground;

      private = {
        bg = secondary-background;
        fg = foreground;
      };
    };

    insert = {
      bg = info;
      fg = inverted-foreground;
    };

    normal = {
      bg = background;
      fg = foreground;
    };

    passthrough = {
      bg = secondary-info;
      fg = inverted-foreground;
    };

    private = {
      bg = secondary-background;
      fg = foreground;
    };

    progress.bg = info;

    url = {
      error.fg = error;
      fg = foreground;
      hover.fg = foreground;

      success = {
        http.fg = secondary-info;
        https.fg = info;
      };

      warn.fg = warning;
    };
  };

  tabs = {
    bar.bg = background;

    even = {
      bg = secondary-background;
      fg = foreground;
    };

    indicator = {
      error = error;
      start = secondary-info;
      stop = info;
    };

    odd = {
      bg = background;
      fg = foreground;
    };

    pinned = {
      even = {
        bg = info;
        fg = inverted-foreground;
      };

      odd = {
        bg = secondary-info;
        fg = inverted-foreground;
      };

      selected = {
        even = {
          bg = selection-background;
          fg = foreground;
        };

        odd = {
          bg = selection-background;
          fg = foreground;
        };
      };
    };

    selected = {
      even = {
        bg = selection-background;
        fg = foreground;
      };

      odd = {
        bg = selection-background;
        fg = foreground;
      };
    };
  };

  webpage = {
    darkmode.enabled = true;
    preferred_color_scheme = "dark";
  };
}
