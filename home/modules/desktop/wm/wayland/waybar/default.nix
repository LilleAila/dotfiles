{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.settings.wm.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.settings.wm.waybar.enable {
    # Random dependencies that may or may not be needed idk
    home.packages = with pkgs; [
      libnotify
      pamixer
      pavucontrol
      playerctl
      brightnessctl
      wlr-randr
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "graphical-session.target";
      settings.bar = {
        layer = "top";
        # output = map (m: m.name) config.settings.monitors;
        position = "top";
        height = lib.fonts.round ((lib.fonts.toPx config.settings.fonts.size) * 2.5);
        spacing = 20;
        modules-left = [
          "clock"
          "niri/workspaces"
          "sway/workspaces" # only one will show at a time
        ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "battery"
          # "wireplumber"
          "pulseaudio" # More configureable
          "bluetooth"
          "network"
          "idle_inhibitor"
          # "tray"
          "group/systray"
          "custom/notifications"
        ];

        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            on-scroll = 1;
            format = with config.colorScheme.palette; {
              months = "<span color='#${base06}'><b>{}</b></span>";
              days = "<span color='#${base05}'><b>{}</b></span>";
              weeks = "<span color='#${base0E}'><b>{:%W}</b></span>";
              weekdays = "<span color='#${base0A}'><b>{}</b></span>";
              today = "<span color='#${base08}'><b><u>{}</u></b></span>";
            };
          };
        };

        "niri/window" = {
          icon = true;
        };

        battery = {
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon} {time}";
          format-discharging = "{capacity}% {icon} {time}";
          tooltip-format = "Plugged in";
          tooltip-format-charging = "{power}W - {time} until full";
          tooltip-format-discharging = "{power}W - {time} until empty";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}󰂯 ";
          format-muted = "";
          format-icons.default = [
            ""
            ""
            ""
          ];
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        bluetooth = {
          format = "{status} ";
          format-connected = "{num_connections} connected ";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_battery_percentage}% 󰁹 ";
          on-click = "blueman-manager";
        };

        network = {
          format = "{ifname} ";
          format-wifi = "{essid} {icon}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          format-disconnected = "󰤮";
          tooltip-format = "{ifname} via {gwaddr} ";
          tooltip-format-wifi = "{essid} ({signalStrength}%) {icon}";
          tooltip-format-ethernet = "{ifname} 󰈀";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "${config.settings.terminal.emulator.exec} nmtui-connect";
          on-click-right = "${config.settings.terminal.emulator.exec} nmtui-edit";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
            # deactivated = "󰛊";
          };
          tooltip = true;
          tooltip-format-activated = "Sleep disabled";
          tooltip-format-deactivated = "Sleep enabled";
          start-activated = false;
        };

        # CSS conflicts if the group is also called "tray"
        "group/systray" = {
          modules = [
            "custom/tray-label"
            "tray"
          ];
          orientation = "inherit";
          drawer = {
            transition-duration = 0;
          };
        };

        "custom/tray-label" = {
          format = "";
        };

        tray = {
          icon-size = lib.fonts.toPx config.settings.fonts.size;
          spacing = 10;
        };

        "custom/notifications" = {
          tooltip = false;
          format = "{icon}";
          format-icons = with config.colorScheme.palette; {
            notification = "<span foreground='#${base08}'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='#${base08}'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='#${base08}'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='#${base08}'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };

      style = pkgs.stdenv.mkDerivation {
        name = "waybar.css";
        nativeBuildInputs = [ pkgs.sass ];
        src = pkgs.writeTextFile {
          name = "waybar.scss";
          text = import ./style.nix config;
        };
        unpackPhase = "true";
        buildPhase = ''
          sass $src $out
        '';
      };

    };
  };
}
